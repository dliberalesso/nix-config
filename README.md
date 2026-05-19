# nix-config

[![Build & Cache](https://github.com/dliberalesso/nix-config/actions/workflows/build-and-cache.yml/badge.svg)](https://github.com/dliberalesso/nix-config/actions/workflows/build-and-cache.yml)

> My personal NixOS configuration using flakes, unify, and Home Manager

## Overview

A modular, reproducible NixOS configuration managing multiple systems with shared and host-specific settings. Built with modern Nix patterns including flake-parts and the unify framework.

## ✨ Features

- 🎨 **Catppuccin theme** system-wide (GTK, Qt, terminal, editors)
- 🪟 **Niri-based desktop session** today, with desktop/session wiring evolving toward narrower reusable modules
- 📝 **Neovim** configured via nixCats with LSP, treesitter, and custom plugins
- 🐚 **Modern CLI** - Fish shell with bat, eza, fzf, zoxide, atuin, direnv
- 🔄 **Version control** - Git + Jujutsu (jj) integration
- 🎵 **Customized Spotify** via Spicetify
- 🐳 **Podman** containerization
- 🔧 **Automated formatting** with treefmt (nixfmt, prettier, stylua, etc.)
- ✅ **CI/CD** with GitHub Actions for builds and caching
- 🤖 **LLM Agents** integration via llm-agents.nix

## 🖥️ Hosts

- **nixavell** - Main laptop with the current Niri-based desktop environment
- **nixwsl** - Minimal WSL2 development environment
- **testvm** - Testing virtual machine

## 🛠️ Tech Stack

- **OS**: NixOS with flakes
- **Framework**: [unify](https://codeberg.org/quasigod/unify.git)
- **Desktop**: Niri-based session today; shared GUI layer plus desktop/session modules
- **Shell**: Fish with modern tools
- **Editor**: Neovim (nixCats)
- **VCS**: Git + Jujutsu
- **Theme**: Catppuccin
- **Build**: nh (Nix Helper), just

## 🚀 Quick Start

### Commands

All commands use [just](https://github.com/casey/just) (see `justfile` for all options):

```bash
just rebuild  # Rebuild and switch configuration
just fmt      # Format all code
just lint     # Check configuration
just update   # Update flake inputs
just clean    # Garbage collect and optimize
```

### Adding a New Host

1. Read `.rpiv/guidance/hosts/architecture.md`
2. Create `hosts/newhostname/newhostname.nix`
3. Register the host with `unify.hosts.nixos.<hostname>` and select reusable modules
4. Add hardware/filesystem specifics in the host directory
5. Rebuild with `just rebuild`

### Project Structure

```
.
├── .rpiv/guidance/ # Canonical architecture/workflow guidance
├── hosts/          # Concrete machine definitions
├── modules/        # Reusable capabilities, packages, programs, and profiles
│   ├── flake/      # flake-parts tooling
│   ├── hardware/   # Hardware-oriented reusable settings
│   ├── meta/       # Shared user/host/flake metadata
│   ├── nix/        # Nix daemon and registry settings
│   ├── nvim/       # Neovim + nixCats layer
│   ├── packages/   # Custom packages and package install sets
│   ├── programs/   # Program/application configuration modules
│   ├── scripts/    # Custom script packages
│   ├── services/   # Reusable system service fragments
│   ├── system/     # Core OS/platform capabilities
│   ├── theme/      # Shared visual/theme configuration
│   └── toplevel/   # Global baselines and high-level profiles
├── flake.nix       # Flake definition
└── justfile        # Task runner commands
```

## 📖 Documentation

- [.rpiv/guidance/architecture.md](./.rpiv/guidance/architecture.md) - Canonical entrypoint for architecture/workflow docs; subfolder guides mirror the project structure
- [AGENTS.md](./AGENTS.md) - Development guidelines for AI assistants
- [justfile](./justfile) - All available commands

## 📝 License

See [LICENSE](./LICENSE)
