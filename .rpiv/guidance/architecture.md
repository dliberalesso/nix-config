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
