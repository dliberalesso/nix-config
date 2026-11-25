# Project Overview

This is a personal Nix flake for building NixOS machines, Home Manager environments, custom packages, and editor/tooling setup. The architecture centers on `flake-parts` + `import-tree` for discovery and `unify` for composing reusable modules into concrete hosts.

# Architecture

```text
flake.nix
├── hosts/      # concrete machines
└── modules/    # reusable capabilities and global defaults
    ├── flake/  # flake-parts tooling (devshell, treefmt, pre-commit)
    ├── system/ hardware/ services/
    ├── packages/ programs/ nvim/
    ├── theme/
    └── toplevel/
```

Flow: `flake.nix` imports `hosts/` and `modules/` → `modules/` defines global + opt-in `unify` modules → `hosts/` selects reusable modules to produce `nixosConfigurations.<host>`.

# Commands

| Command | Repo-wide                                                              | Path-scoped                | Purpose                                                    |
| ------- | ---------------------------------------------------------------------- | -------------------------- | ---------------------------------------------------------- |
| Format  | `just fmt` (`nix fmt`)                                                 | `nix fmt -- <path>...`     | Format code using treefmt (nixfmt, prettier, stylua, etc.) |
| Lint    | `just lint` (`nix flake check`)                                        | N/A                        | Run flake checks                                           |
| Rebuild | `just rebuild` (`nh os switch . --ask`)                                | N/A                        | Rebuild and switch NixOS configuration                     |
| Update  | `just update` (`nix flake update`)                                     | `nix flake update <input>` | Update flake inputs                                        |
| Diff    | `just diff` (`git diff 'flake.lock'`)                                  | `git diff <path>`          | Show changes to files or lockfile                          |
| Clean   | `just clean` (`nh clean all --nogcroots && sudo nix-store --optimise`) | N/A                        | Garbage collect and optimize Nix store                     |
| Repair  | `just repair` (`sudo nix-store --verify --check-contents --repair`)    | N/A                        | Verify and repair Nix store integrity                      |
| Debug   | `just debug`                                                           | N/A                        | Open Nix REPL with debug flag enabled                      |

# Business Context

This repository is the source of truth for the author’s machine, user, package, and editor configuration. It is optimized for reusable capability modules rather than a generic distribution.

<important if="you are trying to understand how a concrete machine is assembled">
Start with `.rpiv/guidance/hosts/architecture.md`, then follow the selected reusable modules into `.rpiv/guidance/modules/architecture.md` and the relevant sublayer guides.
</important>

<important if="you are adding or changing reusable configuration logic">
Choose the narrowest reusable layer first:
- Core OS subsystems: `.rpiv/guidance/modules/system/architecture.md`
- Hardware drivers and peripherals: `.rpiv/guidance/modules/hardware/architecture.md`
- Applications and user tools: `.rpiv/guidance/modules/programs/architecture.md`
- Package derivations and overlays: `.rpiv/guidance/modules/packages/architecture.md`
- Visual tokens and appearance styling: `.rpiv/guidance/modules/theme/architecture.md`
- Desktop sessions, profiles, and baselines: `.rpiv/guidance/modules/toplevel/architecture.md`
- Editor and Lua configurations: `.rpiv/guidance/modules/nvim/architecture.md`
- Flake tooling, formatters, and devshells: `.rpiv/guidance/modules/flake/architecture.md`
</important>

<important if="you are implementing a full-stack feature across layers (new capability to host)">
1. Package derivation: define in `modules/packages/` if custom software (see `.rpiv/guidance/modules/packages/architecture.md`)
2. Configuration & integration: wire in `modules/programs/` (see `.rpiv/guidance/modules/programs/architecture.md`), `modules/system/` (see `.rpiv/guidance/modules/system/architecture.md`), or `modules/hardware/` (see `.rpiv/guidance/modules/hardware/architecture.md`)
3. Composite profile: bundle in `modules/toplevel/` if multi-service environment (see `.rpiv/guidance/modules/toplevel/architecture.md`)
4. Machine activation: enable capability in `hosts/<host>/<host>.nix` (see `.rpiv/guidance/hosts/architecture.md`)
5. Format and verify: run `nix fmt -- <path>...` and `just lint`
</important>

<important if="you are adding or updating flake inputs">
- Align Nixpkgs follows: `nixpkgs.follows = "llm-agents/nixpkgs"` in `flake.nix:34`
- Follow common inputs (`nixpkgs`, `flake-parts`, `systems`) across tooling and community flakes
- For build-time non-flake inputs, use `flake = false;`
</important>

<important if="you are debugging CI or changing the update workflows">
- `.github/workflows/update-flake-lock.yml` creates/updates a fixed-branch (`build/update-flake-lock`) PR with a fixed subject (`⬆️ build: update flake.lock`) and never amends or force-pushes it. The PR lands by rebase (`merge-method: rebase`, no merge commit); automerge is armed only on the Sunday cron or manual dispatch and waits for a green `Status` check.
- `.github/workflows/build-and-cache.yml` skips the duplicate main push only when the push carries at least one commit, every commit subject starts with `⬆️ build: update flake.lock`, and the latest merged PR from `build/update-flake-lock` has a green `Status` check-run on its head SHA (looked up with `per_page=100`); zero-commit and unverified pushes always build (the gate fails open).
- The fixed commit subject prefix — not the commit SHA, which rebase rewrites — plus the merged PR's head SHA are the lookup keys between the two workflows. Cache keys are content hashes and are not the skip mechanism.
- Formatting for `.github/**` comes from `.editorconfig`: the `[{.*,secrets}/**]` rule unsets indentation for dot directories, so a later `[.github/**]` section re-asserts `indent_style = space` and `indent_size = 2`. Do not pin shfmt flags in `modules/flake/treefmt.nix` to compensate; keep it at bare `shfmt.enable = true;`.
</important>

<important if="you are triaging, claiming, updating, or closing beads issues">
- Issue tracking uses the Beads workspace in `.beads/` with the `br` CLI; never run both trackers against the same workspace. `bv` is a graph-aware triage sidecar: invoke it only with its robot flags (bare `bv` launches a blocking TUI), and run `br sync --flush-only` after any `br` mutation so the JSONL export `bv` reads stays current.
- The full triage/claim/close workflow, robot command tables, and TOON guidance live in the repo skill `.agents/skills/beads/SKILL.md` (source document: PRIME.md in the beads workspace); consult the skill rather than this router for command detail.
</important>
