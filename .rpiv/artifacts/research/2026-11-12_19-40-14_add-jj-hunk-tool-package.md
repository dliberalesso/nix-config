---
date: 2026-11-12T19:40:14+0000
author: Douglas Liberalesso
commit: 56e5313
branch: feat/add-jj-hunk-tool
repository: feat-add-jj-hunk-tool
topic: "Add jj-hunk-tool package"
tags: [research, packages, rust, jj-hunk-tool, jujutsu, flake-parts, unify]
status: ready
last_updated: 2026-11-12T19:40:14+0000
last_updated_by: Douglas Liberalesso
---

# Research: Add jj-hunk-tool package

## Research Question

Package the Rust CLI at https://github.com/mvzink/jj-hunk-tool as a self-contained `modules/packages/jj-hunk-tool.nix`: conventional Nixpkgs Rust builder, pinned to an immutable commit, dual-exported through `packages` and `overlayAttrs`, installed globally via `unify.home` using the caller's `jj` (never a bundled one), plus one `hunk = utilExecFor pkgs.jj-hunk-tool;` alias in `modules/programs/jujutsu.nix` with no new profile and no new flake input.

## Summary

The change is a single new flake-parts module shaped exactly like `modules/packages/defuddle.nix`, plus a one-line alias edit. Discovery needs no registration (any non-underscored `modules/**/*.nix` is auto-imported), the dual export is mandatory in practice because `unify.home` resolves `pkgs.<name>` through the flake overlay rather than through `packages.*`, and global `unify.home` reaches all three hosts (each with exactly one HM user, `dli50`) — so the new derivation gates every host toplevel build in CI.

This would be the repository's **first** Rust package: grep finds zero uses of `rustPlatform`, `buildRustPackage`, `cargoHash`, `cargoLock`, or `cargoSha256`. The pinned nixpkgs (`6dadaf43…`, `flake.lock:277`) ships rustc 1.99.0 and supports both `cargoLock` and `cargoHash`; the developer chose `cargoHash`. Upstream is edition 2024 (MSRV 1.85), MIT, has a committed `Cargo.lock` v4, needs no C system libraries, and reaches Jujutsu by spawning `Command::new("jj")` subprocesses — so an unwrapped binary inheriting the caller's PATH is the only configuration consistent with the requirement. It also spawns `patch`.

The critical build-time hazard: `buildRustPackage` defaults to `doCheck = true`, and upstream's 54 integration tests drive real `jj` repos, so the build must set `doCheck = false;`.

## Detailed Findings

### Package module shape and export contract

The template to copy is `modules/packages/defuddle.nix:8-46`: a `perSystem` header destructuring `{ config, lib, pkgs, ... }`, `overlayAttrs = { inherit (config.packages) defuddle; };` at `:10`, the derivation under `packages` at `:12-37` via `pkgs.buildNpmPackage (finalAttrs: { ... })`, and `unify.home` at `:39-45` installing `pkgs.defuddle`. `modules/packages/zennotes-tui.nix:8-12,49-56` is the same shape with a profile-scoped install instead.

Merge semantics that make this safe:

- `perSystem` is a legacy deferred module whose merge turns every definition into one element of a flat module list (`flake-parts/lib.nix:57`), evaluated once per system — so `config` inside any one package file is the _merged_ perSystem config, not a file-local one.
- `perSystem.packages` is `types.lazyAttrsOf types.package` (`flake-parts/modules/packages.nix:11-15`); different attribute names union, the _same_ name defined twice throws `defined multiple times while it's expected to be unique` (`nixpkgs/lib/options.nix:471-481`). Current owners of `packages =` attrs: `defuddle.nix:12`, `zennotes-tui.nix:12`, `pjeoffice-pro/pjeoffice-pro.nix:13`, `scripts/lazymoji/lazymoji.nix:24`, `programs/fzf.nix:18`, `nvim/nixcats.nix:43` — no collision with `jj-hunk-tool`.
- `overlayAttrs = { inherit (config.packages) <name>; }` is a read-back of the merged value, not a cycle, because `overlayAttrs` forces only attribute _names_ (`types.lazyAttrsOf types.raw`, `easyOverlay.nix:19-21`). It becomes a cycle only if the _derivation body_ reads `config.packages.<itself>` or `config.overlayAttrs.<itself>`, or if it reads `pkgs.<itself>` (which is absent from `prev` inside the overlay re-evaluation).

The two evaluation sites produce the _same_ derivation: the perSystem `pkgs` is `import <nixpkgs> { config.allowUnfree; overlays = [ self.overlays.default inputs.llm-agents.overlays.shared-nixpkgs ]; hostPlatform = system; }` (`modules/meta/nixpkgs.nix:6-13` applied by the NixOS nixpkgs module at `nixos/modules/misc/nixpkgs.nix:353-362`, which outranks flake-parts' `mkOptionDefault` fallback), and the overlay re-evaluates the same module set with `pkgs = lib.mkForce prev` (`easyOverlay.nix:53-58`). Same rev, same config, same overlay order → same `.drv`. No duplicate build.

The one divergence hazard for this package: referencing a **sibling overlay attribute** through `pkgs` inside the derivation (e.g. `nativeBuildInputs = [ pkgs.defuddle ]`) resolves in the `packages.*` evaluation but fails in the overlay evaluation, where `pkgs` is pre-overlay `prev`. The package must depend only on base-nixpkgs attributes.

### Discovery and file naming

`flake.nix:4-11` runs `mkFlake` over `inputs.import-tree [ ./hosts ./modules ]`. The filter predicate is `nixFilter = andNot (hasInfix "/_") (hasSuffix ".nix")` (`import-tree/default.nix:64`), with paths relativized so any path _segment_ starting with `_` is dropped. Consequences:

- `modules/packages/jj-hunk-tool.nix` → auto-imported, no registration anywhere.
- `modules/packages/_irpf.nix`, `modules/packages/_bmad-method.nix`, `modules/packages/espanso/_espanso-capdacoverride.nix` → not imported; the latter two are reachable only through explicit relative imports (`modules/packages/pjeoffice-pro/pjeoffice-pro.nix:8` uses `pkgs.callPackage ./_pjeoffice-pro.nix { }`, which bypasses module discovery entirely). `# irpf` is commented out at `hosts/nixavell/nixavell.nix:23`.
- `hosts/nixavell/_filesystem.nix` is excluded the same way and imported explicitly at `hosts/nixavell/nixavell.nix:31`.

The flat-file layout is the prescribed shape for a simple package (`.rpiv/guidance/modules/packages/architecture.md:77`); the `<pkg>/<pkg>.nix` + `_<pkg>.nix` split is for cases with helper assets or a derivation needing system-evaluated config (`pjeoffice-pro/`, `espanso/`). A self-contained `buildRustPackage` needs neither, since `src` comes from `fetchFromGitHub`.

`systems = [ "x86_64-linux" ]` (`modules/flake/default.nix:14`) — the attribute path is `packages.x86_64-linux.jj-hunk-tool`, and no other system is materialized.

### Rust derivation specifics

No in-tree precedent exists. Facts that constrain the derivation:

- `rustPlatform.buildRustPackage` resolves `cargoDeps` from, in order, `cargoVendorDir`, `cargoDeps`, `cargoLock`, then `cargoHash` (throwing if all are null) — `pkgs/build-support/rust/build-rust-package/default.nix:72-84`.
- `doCheck = args.doCheck or true;` (`:169`), and `cargoCheckHook` runs `cargo test` (`hooks/cargo-check-hook.sh:40`).
- `cargoInstallHook` copies built executables straight into `$out/bin` (`hooks/cargo-install-hook.sh:32-34`). There is **no** `makeWrapper`/`wrapProgram` anywhere in `pkgs/build-support/rust`, and no repo-wide hook, overlay, or `postFixup` convention that would wrap a new package (the only in-tree wrappers are explicit per-package ones: `_bmad-method.nix:27-38`, `_irpf.nix:26-38`, `pjeoffice-pro/_pjeoffice-pro.nix:33,61-74`).
- `meta.mainProgram` is _not_ required by `lib.getExe` — it falls back to `lib.getName` with a deprecation warning (`lib/meta.nix:525-540`) — but every in-tree custom package sets it (`defuddle.nix:33`, `zennotes-tui.nix:43`, `_bmad-method.nix:45`, `_pjeoffice-pro.nix:94`). `nix run` falls back to `pname` (`nix3-run` manual), so it works either way; set it to stay warning-free.
- The repo's hash-discovery idiom is a commented `# <attr> = lib.fakeHash;` directly above the pinned hash: `defuddle.nix:21-25`, `zennotes-tui.nix:22-26`, `_bmad-method.nix:18-22`, `_irpf.nix:12`.
- Every existing `fetchFromGitHub` pins by `tag` (`defuddle.nix:20`, `zennotes-tui.nix:20`, `_bmad-method.nix:17`); the sole `rev` pin is `modules/theme/cursor.nix:24`. No package uses an `unstable-` version label.

### Upstream facts

- HEAD of `main`: `97ebf97ba37fc8304c81bac1ba3272bdfe207d0f`, committed 2026-10-23 (message "Merge installed workflow skills with dependency refresh"). The most recent commit touching `src/` is `817a3d19cab8ed9bf04ebf64f2f3073fe195d641`.
- `Cargo.toml`: `name = "jj-hunk-tool"`, `version = "0.1.0"`, `edition = "2024"`, no `rust-version`, no `[[bin]]` (binary name derives from the package name, entrypoint `src/main.rs`).
- Dependencies: `anyhow = "1"`, `clap = { version = "4", features = ["derive"] }`, `console = "0.16"`, `git-surgeon = "0.1.14"`, `syntect = { version = "5", default-features = false, features = ["default-fancy"] }`, `tempfile = "3"`. Resolved in lock: anyhow 1.0.104, clap 4.6.7, console 0.16.6, git-surgeon 0.1.17, syntect 5.3.0, tempfile 3.27.0.
- `Cargo.lock` is committed (version 4). License MIT (`LICENSE`, "Copyright (c) 2026 Michael Victor Zink").
- No C system dependencies: `syntect` uses pure-Rust `fancy-regex` (not Oniguruma) and pure-Rust compression; `git-surgeon` pulls no `git2`/`libgit2`/`gix`/`openssl`.
- Jujutsu access is subprocess-only, via bare `Command::new("jj")`: `src/diff.rs:10` (`root --no-pager`), `:27` (`file annotate`), `:54`/`:89` (`log`), `:112` (`op log`), `:132`/`:158` (`diff --git --no-pager`), and `src/tool.rs:192` (mutating commands, re-invoking itself through `--config merge-tools.jj-hunk-tool.program=<current_exe>`). No Jujutsu crate is a dependency.
- `patch` is a second runtime PATH dependency: `src/tool.rs:550` runs `Command::new("patch").args(["-p1", "--silent"])` for the `_jj-tool` apply path.
- Tests: 21 unit tests inside `src/` (`src/main.rs:408-485` range parsing; `src/tool.rs:604-716` header/fingerprint) are pure Rust. `tests/integration.rs` holds 54 tests, each building a `TestRepo` by running `jj git init` (`tests/integration.rs:17-27`) and then driving `jj`/`patch` — they cannot pass in a Nix build sandbox without those binaries.

### Jujutsu alias mechanics

`modules/programs/jujutsu.nix` is a `unify.home` module. `utilExecFor = script: [ "util" "exec" "--" "${lib.getExe script}" ];` sits at `:48-53`; existing aliases are at `:66` (`cm`), `:68` (`dm`), `:70` (`dm-`), `:72` (`pre-commit`), `:74` (`sq`), plus a hand-written list at `:76-83` (`tug`). `programs.jujutsu.enable = true;` is at `:62`, and Home Manager's Jujutsu module then installs `cfg.package` (default `pkgs.jujutsu`) — so `jj` itself is guaranteed on hosts using this module.

`jj util exec` forwards trailing arguments verbatim: upstream docs state "Additional arguments are passed through" and prescribe the `["util", "exec", "--", "my-jj-script"]` shape precisely so that flags reach the script instead of being parsed by `jj`. With the pinned Jujutsu 0.46.0, `jj hunk split abc1234 -m msg` becomes `jj util exec -- <store>/bin/jj-hunk-tool split abc1234 -m msg`, and `jj hunk --help` shows the tool's own help. Exactly one `--` is needed, inside the alias definition; no second one at the call site. This matches upstream's documented alias, differing only by substituting the absolute store path for a PATH-resolved name.

The list form is valid for Home Manager's `programs.jujutsu.settings`, which is generated from `pkgs.formats.toml` and permits nested lists (`lib/types.nix:2394-2403`); `tug` at `:76-83` is already a list.

`pkgs.jj-hunk-tool` only exists inside this module if the package module exports `overlayAttrs`, since the host nixpkgs gets `self.overlays.default` (`modules/meta/nixpkgs.nix:10-13`) and that overlay is synthesized from `overlayAttrs` alone.

### Global install reach and build gating

`unify.home` is `types.deferredModule` (unify `modules/modules.nix:12-13`); every in-tree definition becomes an entry in one imports list, and `home.packages` (a list option) concatenates. Unify then builds each host as `nixosSystem` over `nixosModules ++ [ home-manager.nixosModules.default { home-manager.users = users; } ]`, injecting `homeModules = [ config.unify.home hostConfig.home ]` into **every** user — independent of which bundles the host selected (unify `modules/nixos.nix:59-90`).

Hosts: `nixavell` (`hosts/nixavell/nixavell.nix:11`, bundles `facter gui laptop podman niride work`, user at `:46`), `nixwsl` (`hosts/nixwsl/nixwsl.nix:11`, bundles `podman wsl`, user at `:27`), `testvm` (`hosts/testvm/testvm.nix:10`, no bundles, user at `:50`). All three register exactly one HM user from `modules/meta/user.nix:11` (`username = "dli50"`), and `testvm` is **not** system-only — its built `etc` derivation links `profiles/per-user/dli50`. No host can currently opt out of global `unify.home`.

Why `pkgs.<name>` resolves in HM at all: `home-manager.useGlobalPkgs = true` (`modules/toplevel/home.nix:35`) makes HM skip its own nixpkgs module (`modules/misc/nixpkgs-disabled.nix`) and take the NixOS `pkgs` (`modules/modules.nix:101-109`). `useUserPackages = true` (`:36`) then places `home.packages` in `/etc/profiles/per-user/dli50`, which is inside each host's system closure. Realized in this store: `nixwsl`'s toplevel contains `etc/profiles/per-user/dli50/bin/defuddle`, and `home-manager-path` lists `defuddle-0.19.6.drv` — the same path a new package would take.

Therefore a failing `jj-hunk-tool` build fails all three host toplevels, and an evaluation failure in the module breaks `nixosConfigurations` evaluation entirely.

### CI behavior

The package matrix is pure enumeration: `nix_eval .#packages.x86_64-linux --apply builtins.attrNames --json` (`.github/scripts/generate-build-matrix.sh:29`), then `.drvPath` for all packages (`:72`), one combined `nix build --dry-run --no-link` (`:78`), and per-entry inclusion when the entry's drv path appears in the dry-run plan (`:79-88`). A brand-new derivation is never substitutable, so it always enters the matrix. `needs_build()` (`:52-67`) — including its "dry-run failed ⇒ build anyway" fallback — is only used on the hosts branch (`:94`); it is dead code for packages, and the `|| true` at `:78` means a failed combined dry-run can silently zero the whole package matrix.

Failure routing: a package **build** failure fails `build-targets` and `Status`, and skips `check` + `build-hosts` (`build-and-cache.yml:95,142,195`). A package **eval** failure fails `setup-matrix` and `Status`. A failure to _evaluate host configs_ (e.g. `pkgs.jj-hunk-tool` missing because `overlayAttrs` was omitted) passes the package leg and fails `check` (`:133`), skipping hosts. Only `x86_64-linux` is ever built — `systems` is a single entry, every job runs `ubuntu-latest`, and `nix flake check` is called without `--all-systems`.

`just lint` is `nix flake check` (`justfile:36-38`). It catches evaluation errors (it forces each `packages.*` drvPath and each host's `toplevel`) but **not** a wrong `hash`/`cargoHash`, a nonexistent repo, a compile failure, or a missing `meta.mainProgram` — those only surface at build or run time. No `checks.*` outputs are declared by this repo; `treefmt.flakeCheck = false` (`modules/flake/treefmt.nix:26`), so formatting is enforced only by the pre-commit hook (`modules/flake/pre-commit.nix:16-38`: treefmt → nixfmt/deadnix/statix, editorconfig-checker, whitespace/EOF fixers, gitleaks).

## Code References

- `flake.nix:4-11` — `mkFlake` + `import-tree [ ./hosts ./modules ]`; the whole discovery mechanism
- `modules/packages/defuddle.nix:8-46` — canonical self-contained package: dual export, `finalAttrs`, fakeHash comments, global `unify.home`
- `modules/packages/zennotes-tui.nix:8-56` — same shape, profile-scoped install, `meta.mainProgram = "zn"`
- `modules/packages/pjeoffice-pro/pjeoffice-pro.nix:2-23` — public-module + `callPackage ./_pjeoffice-pro.nix` split
- `modules/meta/nixpkgs.nix:6-13,17-19,21-35` — overlay list, easyOverlay import, shared nixpkgs for perSystem and hosts
- `modules/toplevel/home.nix:32-37` — `useGlobalPkgs = true`, `useUserPackages = true`
- `modules/programs/jujutsu.nix:48-53,61-83` — `utilExecFor`, `programs.jujutsu.enable`, alias table
- `modules/scripts/lazymoji/lazymoji.nix:8-34` — script-package precedent with `runtimeInputs` (the wrapping idiom deliberately NOT used here)
- `modules/theme/cursor.nix:21-25` — sole `rev`-pinned `fetchFromGitHub` in the tree
- `modules/flake/default.nix:14` — `systems = [ "x86_64-linux" ]`
- `modules/flake/treefmt.nix:26,35-37` — formatter set, `flakeCheck = false`
- `modules/flake/pre-commit.nix:16-38` — hooks that gate a new `.nix` file
- `.github/scripts/generate-build-matrix.sh:29,52-67,72,78-88,94` — package matrix enumeration and inclusion test
- `.github/workflows/build-and-cache.yml:46,57,90,95,133,142,182,195` — job graph and failure routing
- `hosts/nixavell/nixavell.nix:11-46`, `hosts/nixwsl/nixwsl.nix:11-27`, `hosts/testvm/testvm.nix:10-50` — the three host registrations
- `modules/meta/user.nix:7-28` — single canonical `username = "dli50"` reused as `hostConfig.user`

## Integration Points

### Inbound References

- `modules/packages/jj-hunk-tool.nix` — new; auto-imported by `flake.nix:4-11`, contributes `perSystem.packages`/`overlayAttrs` and `unify.home`
- `modules/programs/jujutsu.nix:65-83` — new `hunk` alias consuming `pkgs.jj-hunk-tool` via `utilExecFor`
- `.github/scripts/generate-build-matrix.sh:29` — will enumerate the new package automatically
- `modules/meta/nixpkgs.nix:10-13` — applies the synthesized overlay so `pkgs.jj-hunk-tool` exists on hosts

### Outbound Dependencies

- `modules/meta/nixpkgs.nix:6-13` — base nixpkgs + overlays the derivation may use (nothing overlay-provided may be referenced from inside the derivation)
- `flake.lock:277` — nixpkgs `6dadaf43…` supplying rustc 1.99.0 and `buildRustPackage`
- upstream `97ebf97` — source and `Cargo.lock`
- runtime PATH, not the derivation: `jj` (caller's active install) and `patch` (`src/tool.rs:550`)

### Infrastructure Wiring

- `flake.nix:4-11` (import-tree) → `modules/packages/jj-hunk-tool.nix` (perSystem) → `flake.packages.x86_64-linux` (transposition) and `flake.overlays.default` (easyOverlay)
- `modules/toplevel/home.nix:35-36` (`useGlobalPkgs`, `useUserPackages`) → `unify.home` `pkgs` resolution → `/etc/profiles/per-user/dli50` → host toplevel
- `.github/workflows/build-and-cache.yml:57` (`fail-fast: false`) — the new package gets an isolated CI leg

## Architecture Insights

- **Path is registration.** The only way to add a package is to place a non-underscored `.nix` file under `modules/`; an underscore anywhere in the relative path (any segment) removes it from discovery silently.
- **The dual export is load-bearing, not stylistic.** `overlayAttrs` is the only channel by which `pkgs.<name>` exists for hosts and Home Manager; `packages.<name>` is the build/CI surface. Omitting either half breaks a distinct consumer without a Nix evaluation error in the _other_ half's context.
- **Overlay re-evaluation is `pkgs = prev`.** Any reference to a sibling overlay attribute from inside a derivation's arguments fails in the overlay path, not the `packages.*` path — which makes the failure look like a host-config bug.
- **Global `unify.home` is the strongest scope available.** It needs no host edit, but every added package lengthens all three host closures and gates their CI builds.
- **Fixed-output hashes are invisible to `nix flake check`.** Build success is the only verification of `hash`/`cargoHash`; this is exactly why `lib.fakeHash` comments exist as an update affordance.
- **`lib.getExe` degrades softly.** A missing or wrong `meta.mainProgram` yields a warning or a run-time failure, never an eval failure — so the alias can look wired up while being broken.

## Precedents & Lessons

4 similar past changes analyzed.

### Precedent: defuddle — custom GitHub package, dual-exported + globally installed

**Commit(s)**: `ae065fa` — "✨ feat: add defuddle package" (2026-03-31)
**Blast radius**: 1 file, 1 layer — `modules/packages/defuddle.nix`.

**Follow-up fixes**: none. Only `⬆️ build:` version bumps (`3c2cd40`, `52b9b11`, `75226a2`, `a234470`, `1b52905`), each rewriting source + deps hashes.

**Takeaway**: the closest template has never needed a repair commit — copy its shape verbatim, including `finalAttrs` and the commented `# <hash> = lib.fakeHash;`.

### Precedent: zennotes-tui — same shape, host-scoped install

**Commit(s)**: `218d6fa` — "✨ feat: add ZenNotes TUI to nixwsl" (2026-10-28). Installs via `unify.modules.wsl.home` instead of `unify.home`. No follow-ups.
**Takeaway**: both scopes are live conventions; global scope adds host-closure weight that the profile scope avoids.

### Precedent: helixnotes — fresh fetcher package needing an emergency fix

**Commit(s)**: `db0aff6` (2026-06-29) → `d24378b` — "🚑 fix: update fetcherVersion to 4 for helixnotes pnpm deps" (2026-07-13) → removed in `29144c4`.
**Takeaway**: fetcher-level details bite weeks later, not on the first build. For Rust the analogue is hash/vendor-shape drift.

### Precedent: jj alias churn

**Commit(s)**: `7efd208` (2025-06-18), `84d06f9`, `1bab729`, `3317c92` ("jj sq", +12 lines via `utilExecFor`); `821568a` removed a redundant `set -euo pipefail` from a `writeShellApplication`; `jujutsu.nix` was rewired by refactors `c2895e4`, `86c2657`, `2a62811`, `268c8ac`.
**Takeaway**: `utilExecFor` is the stable idiom and always takes a store path via `lib.getExe` — a PATH-based alias would break the established shape.

### Composite Lessons

- New upstream-sourced packages in this repo are added and sometimes reverted within days (`cd640b3` added two packages, reverted in `7889933`; `53f7b57`→`765a040`); the disable convention is prefixing the filename with `_` (`3accb2e`). Build before committing.
- No CI edit is ever needed — the matrix derives from `builtins.attrNames` of `packages.<system>`.
- One past package addition had to be platform-gated when the overlay broke on a non-default platform (`c2fdad9`); here `systems` is x86_64-linux only, so the risk is low.
- Hash/version refreshes land as separate `⬆️ build:` commits, never mixed into the feature commit.

## Historical Context (from `.rpiv/artifacts/`)

- `.rpiv/artifacts/discover/2026-11-12_19-19-46_add-jj-hunk-tool.md` — the FRD this research answers (requirements, seven decisions, build-only validation scope)

## Developer Context

**Q (discover: Dual package exports): Pre-resolved from codebase evidence — reusable custom packages are exported through both `packages.<name>` and `overlayAttrs.<name>`; keep or change?**
A: Keep dual exports.

**Q (discover: Global user installation): Install for all users via global `unify.home`, export only without installing, or create an opt-in profile?**
A: Install for all users through global `unify.home`.

**Q (discover: Self-contained package module): Where should the Home Manager installation live relative to the derivation?**
A: Self-contained `modules/packages/jj-hunk-tool.nix` containing derivation, dual exports, and installation.

**Q (discover: Immutable source pin): Upstream has no tags or releases. How should the source be selected?**
A: Pin an exact immutable commit with a fixed hash.

**Q (discover: Jujutsu command alias): Should this add upstream's suggested `jj hunk` alias?**
A: Add `jj hunk` through the existing `utilExecFor` pattern.

**Q (discover: Caller-provided runtime Jujutsu; supersedes an earlier Lazymoji-style answer): Should the command supply its own Jujutsu?**
A: "The package should not provide it's own jj." — unwrapped, caller's PATH.

**Q (discover: Build-only completion validation): Which checks define done?**
A: Build only (`nix build .#jj-hunk-tool`).

**Q (`pkgs/build-support/rust/build-rust-package/default.nix:169`): `buildRustPackage` defaults to `doCheck = true`, but upstream `tests/integration.rs:17-27` runs `jj git init` and `patch` against real repositories. How should the check phase be configured given the build-only scope?**
A: Disable tests in the build — `doCheck = false;`.

**Q (`pkgs/build-support/rust/build-rust-package/default.nix:72-84`): No Rust package exists in the tree; the pinned nixpkgs supports `cargoLock` and `cargoHash`, and upstream commits `Cargo.lock`. Which pinning mechanism?**
A: `cargoHash` pin, using the repo's `# cargoHash = lib.fakeHash;` iteration idiom (as in `modules/packages/zennotes-tui.nix:22-26`) — not `cargoLock`.

**Q (upstream `src/tool.rs:550`): Beyond `jj`, upstream shells out to `patch` for `split`/`squash`/`diffedit`/`restore`. How should `patch` be handled?**
A: Leave unwrapped; rely on the caller's PATH (`patch` is already on NixOS hosts via `corePackages`).

**Q (upstream `Cargo.toml`, HEAD `97ebf97` dated 2026-10-23, no in-tree `unstable-` precedent): What `version` should the derivation declare?**
A: `0.1.0-unstable-2026-10-23` — unstable label using the commit date.

## Related Research

- None yet.

## Open Questions

- Non-NixOS consumers running `nix run .#jj-hunk-tool` must supply both `jj` and `patch` themselves; the FRD accepted this for `jj` and the same was accepted for `patch`. Whether any such consumer exists is out of scope for this change.
- The FRD carried no deferred items.
