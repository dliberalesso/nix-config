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

| Command | Repo-wide                                     | Path-scoped                           | Purpose                                                    |
| ------- | --------------------------------------------- | ------------------------------------- | ---------------------------------------------------------- |
| Format  | `just fmt` (`nix fmt`)                        | `treefmt <path>...` (within devshell) | Format code using treefmt (nixfmt, prettier, stylua, etc.) |
| Lint    | `just lint` (`nix flake check`)               | N/A                                   | Run flake checks                                           |
| Rebuild | `just rebuild` (`nh os switch . --ask`)       | N/A                                   | Rebuild and switch NixOS configuration                     |
| Update  | `just update` (`nix flake update`)            | `nix flake update <input>`            | Update flake inputs                                        |
| Diff    | `just diff` (`jj diff 'flake.lock'`)          | N/A                                   | Show changes to flake.lock                                 |
| Clean   | `just clean` (`nh clean all --nogcroots`)     | N/A                                   | Garbage collect and optimize Nix store                     |
| Repair  | `just repair` (`sudo nix-store --verify ...`) | N/A                                   | Verify and repair Nix store integrity                      |
| Debug   | `just debug`                                  | N/A                                   | Open Nix REPL with debug flag enabled                      |

# Business Context

This repository is the source of truth for the author’s machine, user, package, and editor configuration. It is optimized for reusable capability modules rather than a generic distribution.

<important if="you are trying to understand how a concrete machine is assembled">
Start with `.rpiv/guidance/hosts/architecture.md`, then follow the selected reusable modules into `.rpiv/guidance/modules/architecture.md` and the relevant sublayer guides.
</important>

<important if="you are adding or changing reusable configuration logic">
Choose the narrowest reusable layer first: `.rpiv/guidance/modules/system/architecture.md`, `.rpiv/guidance/modules/programs/architecture.md`, `.rpiv/guidance/modules/packages/architecture.md`, `.rpiv/guidance/modules/toplevel/architecture.md`, or `.rpiv/guidance/modules/nvim/architecture.md`. Keep host-only facts out of reusable modules.
</important>
