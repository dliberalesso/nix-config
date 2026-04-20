# nix-config

[![Build & Cache](https://github.com/dliberalesso/nix-config/actions/workflows/build-and-cache.yml/badge.svg)](https://github.com/dliberalesso/nix-config/actions/workflows/build-and-cache.yml)

> My personal NixOS configuration using flakes, unify, and Home Manager

## Overview

A modular, reproducible NixOS configuration managing multiple systems with shared and host-specific settings. Built with modern Nix patterns including flake-parts and the unify framework.

## ✨ Features

- 🎨 **Catppuccin theme** system-wide (GTK, Qt, terminal, editors)
- 🪟 **Hyprland** Wayland compositor with custom panel and lock screen
- 📝 **Neovim** configured via nixCats with LSP, treesitter, and custom plugins
- 🐚 **Modern CLI** - Fish shell with bat, eza, fzf, zoxide, atuin, direnv
- 🔄 **Version control** - Git + Jujutsu (jj) integration
- 🎵 **Customized Spotify** via Spicetify
- 🐳 **Podman** containerization
- 🔧 **Automated formatting** with treefmt (nixfmt, prettier, stylua, etc.)
- ✅ **CI/CD** with GitHub Actions for builds and caching
- 🤖 **LLM Agents** integration via llm-agents.nix

## 🖥️ Hosts

- **nixavell** - Main laptop with full Hyprland desktop environment
- **nixwsl** - Minimal WSL2 development environment
- **testvm** - Testing virtual machine

## 🛠️ Tech Stack

- **OS**: NixOS with flakes
- **Framework**: [unify](https://codeberg.org/quasigod/unify.git)
- **Desktop**: Hyprland, hyprlock, hyprpanel, rofi
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

1. Create `hosts/newhostname/newhostname.nix`
2. Define configuration using `unify.hosts.nixos.newhostname`
3. Add hardware/filesystem specifics
4. Rebuild with `just rebuild`

### Project Structure

```
.
├── hosts/          # Host-specific configurations
├── modules/
│   ├── flake/      # Top-level flake config
│   ├── hardware/   # Hardware settings
│   ├── meta/       # User info, hostname
│   ├── nix/        # Nix daemon settings
│   ├── nvim/       # Neovim configuration
│   ├── packages/   # Custom packages
│   ├── programs/   # Application configs
│   ├── scripts/    # Custom scripts
│   ├── services/   # System services
│   ├── system/     # Core system settings
│   ├── theme/      # Catppuccin theming
│   └── toplevel/   # Top-level abstract configurations
├── flake.nix       # Flake definition
└── justfile        # Task runner commands
```

## 📖 Documentation

- [AGENTS.md](./AGENTS.md) - Development guidelines for AI assistants
- [justfile](./justfile) - All available commands

## 📝 License

See [LICENSE](./LICENSE)
