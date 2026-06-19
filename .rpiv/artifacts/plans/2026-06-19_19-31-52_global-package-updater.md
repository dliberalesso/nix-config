---
date: 2026-06-19T19:31:52+0000
author: Douglas Liberalesso
commit: 246bfcff
branch: main
repository: nix-config
topic: "global-package-updater"
tags: [plan, global-package-updater, python]
status: in-progress
parent: .rpiv/artifacts/research/18-28-01_global-package-updater.md
phase_count: 5
phases:
  - { n: 1, title: "Foundation & Flake Wiring" }
  - { n: 2, title: "Python Updater Core" }
  - { n: 3, title: "NPM Packages Migration" }
  - { n: 4, title: "Legacy Packages Migration" }
  - { n: 5, title: "CI & Pre-commit Hooks" }
unresolved_phase_count: 5
last_updated: 2026-06-19T19:31:52+0000
last_updated_by: Douglas Liberalesso
---

# Global Package Updater Implementation Plan

## Overview

We are implementing a global package updater in Python. The script will be packaged as a Nix derivation and wired into the flake. Package definitions for `defuddle`, `bmad-method`, `irpf`, and `pjeoffice-pro` will be moved to `pkgs/` with their configuration exposed via `passthru.updateConfig`. A global `pkgs/hashes.json` will act as the single source of truth for versions and hashes.

## Requirements

- Centralized `hashes.json` in `pkgs/hashes.json` tracking `version`, `hash`, and `npmDepsHash`.
- Relocate package definitions to `pkgs/` for ergonomic addition/removal.
- Python 3 update script (`pkgs/updater/updater.py`) with `validate` and `update` subcommands.
- Extract package configuration via `passthru.updateConfig` using `nix eval`.
- `npmDepsHash` extracted via dummy hash and parsing Nix build errors.
- Pre-commit hook for `validate`.
- CI workflow modifications for atomic commits per updated package.

## Current State Analysis

Packages (`defuddle`, `bmad-method`, `irpf`, `pjeoffice-pro`) currently hardcode versions and hashes in `modules/packages/`. The flake uses `update-flake-lock` for dependencies, but no automation exists for these custom packages.

### Key Discoveries

- `llm-agents` dummy hash pattern is the only reliable way to compute `npmDepsHash`.
- `pjeoffice-pro` requires HTML scraping, which can be encoded in `passthru.updateConfig` (e.g., regex strings).
- `bmad-method` has a `v` prefix in its GitHub tags that must be stripped.
- Using `import-tree` for `./pkgs` cleanly separates definitions from installation profiles in `modules/packages/`.

## Desired End State

Adding a package is as simple as creating `pkgs/my-package.nix` with a `passthru.updateConfig` block. The pre-commit hook ensures `hashes.json` has a skeleton entry for it. Running `nix run .#updater update` automatically fetches the latest version, computes the source hash, computes `npmDepsHash` if applicable, and updates `hashes.json`.

## What We're NOT Doing

- We are not replacing `flake.lock` updater; this runs alongside it.
- We are not managing Home Manager/NixOS profile installation mappings via the updater; `modules/packages/` continues to own that.
- We are not using TypeScript/Bun; we are using Python 3 for the updater.

## Decisions

### Architecture

- **import-tree for pkgs/**: Cleanly separates definitions from installation mapping, mirroring existing flake architecture.

### Config Extraction

- **passthru.updateConfig**: Exposes configuration natively in Nix. Extracted by Python via `nix eval --json`.

### Execution

- **Python 3**: Wrapped in a Nix `writeShellApplication` for native execution without new runtimes like Bun.

### Data Model

- **Global hashes.json**: Single file simplifies validation and commit tracking.

## Phase 1: Foundation & Flake Wiring

### Overview

Sets up the `pkgs/` directory with `import-tree`, initializes `hashes.json`, and scaffolds the Python updater. Depends on nothing.

### Changes Required:

#### 1. flake.nix:11-14

**File**: `flake.nix`
**Changes**: MODIFY — Add `./pkgs` to the `import-tree` list.

#### 2. pkgs/default.nix

**File**: `pkgs/default.nix`
**Changes**: NEW — Flake-parts module exposing `updater` package and app.

#### 3. pkgs/hashes.json

**File**: `pkgs/hashes.json`
**Changes**: NEW — Empty JSON object `{}`.

#### 4. pkgs/updater/updater.py

**File**: `pkgs/updater/updater.py`
**Changes**: NEW — Python script with `argparse` scaffolding for `validate` and `update`.

#### 5. pkgs/updater/default.nix

**File**: `pkgs/updater/default.nix`
**Changes**: NEW — `writeShellApplication` for `updater.py` with `python3` and `nix` in PATH.

#### 6. modules/flake/shell.nix:15-18

**File**: `modules/flake/shell.nix`
**Changes**: MODIFY — Add `pkgs.updater` to `make-shells.default.packages`.

### Success Criteria:

#### Automated Verification:

#### Manual Verification:

## Phase 2: Python Updater Core

### Overview

Implements the core logic of the Python updater including fetching versions, computing hashes via subprocesses, and the dummy hash pattern. Depends on Phase 1.

### Changes Required:

#### 1. pkgs/updater/updater.py:10-50

**File**: `pkgs/updater/updater.py`
**Changes**: MODIFY — Add `validate` logic (syncing `hashes.json` with `pkgs/*.nix`) and `update` logic (`nix eval`, `nix store prefetch-file`, dummy hash build extraction).

### Success Criteria:

#### Automated Verification:

#### Manual Verification:

## Phase 3: NPM Packages Migration

### Overview

Migrates `defuddle` and `bmad-method` definitions to `pkgs/` and integrates them with `hashes.json`. Depends on Phase 1. Can run in parallel with Phase 4.

### Changes Required:

#### 1. pkgs/hashes.json:2-10

**File**: `pkgs/hashes.json`
**Changes**: MODIFY — Add initial versions and hashes for `defuddle` and `bmad-method`.

#### 2. pkgs/defuddle.nix

**File**: `pkgs/defuddle.nix`
**Changes**: NEW — Package definition for `defuddle` with `passthru.updateConfig`.

#### 3. modules/packages/defuddle.nix:2-27

**File**: `modules/packages/defuddle.nix`
**Changes**: MODIFY — Remove derivation definition, keep only `unify.home` profile mapping.

#### 4. pkgs/bmad-method.nix

**File**: `pkgs/bmad-method.nix`
**Changes**: NEW — Package definition for `bmad-method` with `passthru.updateConfig`.

#### 5. modules/packages/bmad-method.nix:2-42

**File**: `modules/packages/bmad-method.nix`
**Changes**: MODIFY — Remove derivation definition, keep only `unify.home` profile mapping.

#### 6. pkgs/default.nix:5-10

**File**: `pkgs/default.nix`
**Changes**: MODIFY — Export `defuddle` and `bmad-method`.

### Success Criteria:

#### Automated Verification:

#### Manual Verification:

## Phase 4: Legacy Packages Migration

### Overview

Migrates `irpf` and `pjeoffice-pro` to `pkgs/`, preserving their unique configuration needs. Depends on Phase 1. Can run in parallel with Phase 3.

### Changes Required:

#### 1. pkgs/hashes.json:11-20

**File**: `pkgs/hashes.json`
**Changes**: MODIFY — Add initial versions and hashes for `irpf` and `pjeoffice-pro`.

#### 2. pkgs/irpf.nix

**File**: `pkgs/irpf.nix`
**Changes**: NEW — Package definition for `irpf` with `passthru.updateConfig`.

#### 3. modules/packages/irpf.nix:2-36

**File**: `modules/packages/irpf.nix`
**Changes**: MODIFY — Remove derivation definition, keep only `unify.modules.irpf.home` mapping.

#### 4. pkgs/pjeoffice-pro.nix

**File**: `pkgs/pjeoffice-pro.nix`
**Changes**: NEW — Package definition for `pjeoffice-pro` (moved from `_pjeoffice-pro.nix`) with HTML scraping regex in `passthru.updateConfig`.

#### 5. modules/packages/pjeoffice-pro/pjeoffice-pro.nix:2-10

**File**: `modules/packages/pjeoffice-pro/pjeoffice-pro.nix`
**Changes**: MODIFY — Remove `perSystem` block, keep only `unify.modules.work.home` mapping.

#### 6. modules/packages/pjeoffice-pro/\_pjeoffice-pro.nix:1-100

**File**: `modules/packages/pjeoffice-pro/_pjeoffice-pro.nix`
**Changes**: MODIFY — Delete this file.

#### 7. pkgs/default.nix:11-15

**File**: `pkgs/default.nix`
**Changes**: MODIFY — Export `irpf` and `pjeoffice-pro`.

### Success Criteria:

#### Automated Verification:

#### Manual Verification:

## Phase 5: CI & Pre-commit Hooks

### Overview

Integrates the updater into the development workflow and CI pipelines. Depends on Phase 2.

### Changes Required:

#### 1. modules/flake/pre-commit.nix:20-30

**File**: `modules/flake/pre-commit.nix`
**Changes**: MODIFY — Add `validate-packages` hook executing `updater validate`.

#### 2. .github/workflows/update-flake-lock.yml:35-45

**File**: `.github/workflows/update-flake-lock.yml`
**Changes**: MODIFY — Add `updater update` step to emit atomic commits on the PR branch.

### Success Criteria:

#### Automated Verification:

#### Manual Verification:

## Ordering Constraints

- Phase 1 must precede all others.
- Phase 2 must precede Phase 5.
- Phase 3 and Phase 4 can be implemented in parallel after Phase 1.

## Verification Notes

- `npmDepsHash` must refresh correctly for `defuddle` and `bmad-method`.
- Both `hash` and `npmDepsHash` must refresh atomically to prevent build failures.
- `irpf` browser-compat launch-directory post-update regressions must be avoided.

## Performance Considerations

- The updater script runs `nix eval` and `nix build`. It should only trigger these expensive operations if the remote version differs from the tracked version.

## Migration Notes

- Package names must exactly match their keys in `hashes.json` and the file names in `pkgs/`.
- Deleting `modules/packages/pjeoffice-pro/_pjeoffice-pro.nix` implies removing its legacy `updateScript` in favor of the global updater.

## Pattern References

- `modules/packages/llm-agents.nix`: Package collection export pattern.
- `modules/scripts/lazymoji/lazymoji.nix`: Script wrapping pattern via `writeShellApplication`.
- `numtide/llm-agents`: Dummy hash calculation pattern and regex extraction.

## Developer Context

## Plan History

- Phase 1: Foundation & Flake Wiring — pending
- Phase 2: Python Updater Core — pending
- Phase 3: NPM Packages Migration — pending
- Phase 4: Legacy Packages Migration — pending
- Phase 5: CI & Pre-commit Hooks — pending

## References

- `.rpiv/artifacts/research/18-28-01_global-package-updater.md`
- `https://github.com/numtide/llm-agents.nix`
