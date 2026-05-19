# Project Overview

This is a personal Nix flake for building NixOS machines, Home Manager environments, custom packages, and editor/tooling setup. The architecture centers on `flake-parts` + `import-tree` for discovery and `unify` for composing reusable modules into concrete hosts.

# Architecture

```text
flake.nix
├── hosts/      # concrete machines
└── modules/    # reusable capabilities and global defaults
    ├── flake/  # flake-parts tooling
    ├── system/ hardware/ services/
    ├── packages/ programs/ nvim/
    ├── theme/
    └── toplevel/
```

Flow: `flake.nix` imports `hosts/` and `modules/` → `modules/` defines global + opt-in `unify` modules → `hosts/` selects reusable modules to produce `nixosConfigurations.<host>`.

# Commands

| Command        | Purpose                               |
| -------------- | ------------------------------------- |
| `just fmt`     | Format the repo                       |
| `just lint`    | Run `nix flake check`                 |
| `just rebuild` | Rebuild and switch the current system |
| `just update`  | Update flake inputs                   |
| `just debug`   | Open the Nix REPL with debug enabled  |

# Business Context

This repository is the source of truth for the author’s machine, user, package, and editor configuration. It is optimized for reusable capability modules, not for publishing a generic distribution.

<important if="you are trying to understand how a concrete machine is assembled">
Start with `.rpiv/guidance/hosts/architecture.md`, then follow the selected reusable modules into `.rpiv/guidance/modules/architecture.md` and the relevant sublayer guides.
</important>

<important if="you are adding or changing reusable configuration logic">
Choose the narrowest reusable layer first: `.rpiv/guidance/modules/system/architecture.md`, `.rpiv/guidance/modules/programs/architecture.md`, `.rpiv/guidance/modules/packages/architecture.md`, `.rpiv/guidance/modules/toplevel/architecture.md`, or `.rpiv/guidance/modules/nvim/architecture.md`. Keep host-only facts out of reusable modules.
</important>

<important if="you are working on desktop-session changes">
Treat `gui` as the stable desktop-agnostic layer for shared graphical apps, fonts, and theme. Treat `niride` as a transitional Niri bundle; compositor/session-specific work should move toward narrower modules so `niride` and a future `hyprde` can coexist (see `.rpiv/guidance/modules/toplevel/architecture.md`).
</important>

<important if="you are touching theme scheme plumbing">
Check the known architecture issue first: `modules/theme/scheme.nix` references `inputs.base16.lib`, but `flake.nix` does not currently declare `base16`. Fix the missing input before extending that path.
</important>
