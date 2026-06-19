---
date: 2026-06-19T18:28:01+0000
author: Douglas Liberalesso
commit: 246bfcff
branch: main
repository: nix-config
topic: "how does the global package updater script manage centralized hashes"
tags: [research, codebase, packages, global-updater, script]
status: ready
last_updated: 2026-06-19T18:28:01+0000
last_updated_by: Douglas Liberalesso
---

# Research: how does the global package updater script manage centralized hashes

## Research Question

I think weve learned a lot in the last workflow when we updated `modules/packages/defuddle.nix`.
Please create a script that check the releases of all the packages we are building in a similar way, and updates them, calculating the neccessary hashes.
I know `numtide/llm-agents.nix` does something like that by having a `hashes.json` and an `update.py` per package. You could research that implemantation by checking said repo from github in `/tmp`.
Lets implement it by using a global `hashes.json` and a global update script (written in `typescript`).
My idea is to also wire it into `.github/workflows/update-flake-lock.yml`.
We should devise an ergonomic way for the user to add/remove packages for the script to manage.

## Summary

The codebase currently hardcodes `version`, `src.hash`, and `npmDepsHash` inline across `modules/packages/*.nix`. A global TS updater will centralize this state into `pkgs/hashes.json` read via `builtins.fromJSON (builtins.readFile ./hashes.json)`.

To provide ergonomic user management, package definitions and wiring will be relocated to a root `pkgs/` directory (where the TS script scans and validates them against `hashes.json`), separating them from their installation profiles in `modules/packages/`. The TypeScript script will have a `validate` subcommand wired to pre-commit (ensuring `hashes.json` matches the definitions present in `pkgs/`) and an `update` subcommand that securely probes native APIs via `fetch` and computes SRI hashes via `nix store prefetch-file` and isolated `nix build` instances. CI wiring requires bypassing the monolithic `DeterminateSystems/update-flake-lock` git logic to emit one distinct, atomic commit per updated package on the PR branch.

## Detailed Findings

### Centralized `hashes.json` Integration

- The Nix function `builtins.readFile` is evaluated at parse-time. `builtins.fromJSON (builtins.readFile ./hashes.json)` will safely parse the global file.
- The npm packages (`defuddle`, `bmad-method`) require extraction of three values: `version`, `src.hash`, and `npmDepsHash`.
- Non-npm packages (`irpf`, `pjeoffice-pro`) require only `version` and `src.hash`.
- To prevent circular imports and allow uniform access, both `hashes.json` and the package definitions will be housed centrally in `pkgs/` instead of deep within `modules/packages/`.

### TypeScript Update Script Architecture

- **Validation**: A `validate` subcommand will scan `pkgs/` to cross-reference tracked packages against `hashes.json`. It will add blank entries for newly introduced packages and cull obsolete ones, ensuring `hashes.json` is always accurate.
- **Fetching Versions**: GitHub API releases can be queried using Node's native `fetch`. The TS script will strip tag prefixes like `"v"` (seen in `bmad-method`) to store bare versions in the JSON. Legacy scraping (e.g. `pjeoffice-pro`) will use `fetch` and native `RegExp`.
- **Calculating `src.hash`**: Executed via Node's `child_process.execSync("nix store prefetch-file --json ...")` to safely obtain the exact SRI hash.
- **Calculating `npmDepsHash`**: This requires spawning a temporary, isolated `nix build` derivation with a dummy `npmDepsHash = lib.fakeHash`, catching the expected error, and parsing the calculated `sha256-...` hash from the standard error output. This must use robust try/catch blocks to ensure no partial updates are ever written to `hashes.json`.
- **Atomic Commits**: During updates, the script must update `hashes.json`, then automatically stage and commit the change for that specific package before proceeding to the next.

### CI Wiring (`.github/workflows/update-flake-lock.yml`)

- The current workflow delegates PR creation entirely to `DeterminateSystems/update-flake-lock@v28`, which strictly only stages `flake.lock`.
- To support one commit per package and include `hashes.json` modifications, the TS script must be executed _after_ the DS action creates the branch (or the DS action must be replaced with manual git orchestration). The workflow will need Node.js (`actions/setup-node`) to execute the TS script, which will incrementally commit package updates.

## Code References

- `modules/packages/defuddle.nix:15-27` — Current hardcoded strings for version, tag, hash, and npmDepsHash.
- `modules/packages/bmad-method.nix:12-22` — Current hardcoded strings and a tag syntax prefix (`"v${finalAttrs.version}"`) that the script needs to parse around.
- `modules/packages/irpf.nix:10-20` — Uses `lib.head (lib.splitVersion version)` for dynamic pathing.
- `modules/packages/pjeoffice-pro/_pjeoffice-pro.nix:15-24` — Contains the legacy `passthru.updateScript` relying on `curl` and `common-updater-scripts`. This block will be entirely deleted.
- `.github/workflows/update-flake-lock.yml:30` — `DeterminateSystems/update-flake-lock@v28` action that must be worked around for atomic commits.

## Integration Points

### Inbound References

- `pkgs/*.nix:1` — Each derivation will read `builtins.fromJSON (builtins.readFile ./hashes.json)` and enforce failure if its key is missing.

### Outbound Dependencies

- `modules/packages/*.nix:1` — Will continue to install the profiles, pulling derivations that have been exposed via flake `overlayAttrs` / `packages` from `pkgs/`.

### Infrastructure Wiring

- `.github/workflows/update-flake-lock.yml:27` — Integration point for inserting the TS `update` step and `setup-node` environment.
- `modules/flake/pre-commit.nix:1` — Pre-commit hook location to wire the `<script> validate` step.

## Architecture Insights

- **Decoupling Definition from Installation**: Moving package declarations to `pkgs/` ensures the updater script only manipulates standalone software definitions, leaving user-profile mappings untouched in `modules/packages/`.
- **Nix-Driven Truth**: By having the TS script infer existence from the `.nix` packages present in `pkgs/`, the user-ergonomics goal is perfectly met. Adding a file to `pkgs/` implicitly registers it for the updater; removing a file deregisters it.

## Precedents & Lessons

5 similar past changes analyzed.

### Precedent: defuddle release bump with fixed-output hash refresh

**Commit(s)**: `52b9b114` — "⬆️ build: update defuddle to 0.18.1" (2026-04-22)
**Blast radius**: 1 file across 1 layer
`modules/packages/defuddle.nix` — what changed

**Takeaway**: package bumps are safe when hashes stay local, explicit, and version-linked. Both `hash` and `npmDepsHash` must refresh atomically.

### Composite Lessons

- Keep package hashes adjacent to the derivation; the repo’s winning pattern is `version` + `hash` + `npmDepsHash` updated together.
- Expect runtime regressions after package bumps, especially for binary-ish apps (`irpf` showed launch-directory and browser-compatibility fallout post-update).
- The only proven centralized updater in history is for `flake.lock`; package hash centralization is a new design, not an inherited convention.

## Historical Context (from `.rpiv/artifacts/`)

- `.rpiv/artifacts/plans/2026-06-19_11-33-01_update-defuddle-to-0-19-0.md` — validates isolated temporary buildNpmPackage derivations for npmDepsHash extraction.

## Developer Context

**Q (CI PR Workflow): The `DeterminateSystems/update-flake-lock` action strictly stages only `flake.lock` and creates the PR. How should we include the modified `hashes.json` and `.nix` files in the PR?**
A: Run the TS script after the action and add a second commit to the same PR branch with the hashes and .nix changes. (And per updated requirement: emit atomic commits per package updated).

**Q (Schema Design & Ergonomics): To provide an ergonomic way to add/remove packages without the auto-updater overwriting user intent, should we split configuration into two files?**
A: Move definitions to `pkgs/` in the root. The script does two things: `validate` (synced to pre-commit, ensures hashes.json entries strictly mirror pkgs/ content) and `update` (validates, then refreshes versions+hashes atomically). `modules/packages/` will strictly handle installation mapping.

## Open Questions

- How should the TS script dynamically extract configuration parameters (e.g., GitHub owner/repo vs HTML scraping logic) from the `pkgs/*.nix` definitions if the user solely creates Nix files? (e.g., exposing a `passthru.updateConfig` attribute for the script to evaluate via `nix eval`).
