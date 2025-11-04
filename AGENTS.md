# Agent Instructions for nix-config

## Build/Lint/Test Commands

- Format code: `just fmt` (runs treefmt with nixfmt, prettier, stylua, etc.)
- Lint/check: `just lint` (runs nix flake check)
- Rebuild system: `just rebuild` (rebuilds and switches NixOS with nh)
- Update dependencies: `just update` (updates flake inputs)
- Diff lock file: `just diff` (shows changes to flake.lock using jj)
- Clean store: `just clean` (garbage collect and optimize with nh)
- Repair store: `just repair` (verify and repair Nix store integrity)
- Debug in REPL: `just debug` (opens nix repl with debug flag enabled)

## Architecture

### Framework

- Uses **unify** flake for abstracting NixOS + Home Manager configurations
- **flake-parts** with **import-tree** for automatic modular imports
- Most inputs follow `nix-proxy-flake` for centralized nixpkgs version

### Module Organization

- `modules/flake/` - Top-level flake configuration
- `modules/hardware/` - Hardware-specific settings
- `modules/meta/` - User info (username, email, name), hostname, state version
- `modules/nix/` - Nix daemon and package manager settings
- `modules/nvim/` - Neovim configuration using nixCats
- `modules/packages/` - Custom package definitions
- `modules/programs/` - Application configurations (split per-program)
- `modules/scripts/` - Custom shell scripts
- `modules/secrets/` - Secret management
- `modules/services/` - System services
- `modules/system/` - Core system (boot, audio, network, locale, kernel)
- `modules/theme/` - Catppuccin theming (GTK, Qt, cursor, wallpaper)

### Hosts

- `hosts/nixavell/` - Main x86_64-linux machine with GUI (Hyprland)
- `hosts/nixwsl/` - WSL instance with minimal config
- `hosts/testvm/` - Test virtual machine

## Common Patterns

### Defining a Host

```nix
unify.hosts.nixos.${hostName} = {
  modules = [ /* list of modules */ ];
  nixos = {
    # NixOS-specific configuration
    nixpkgs.hostPlatform.system = "x86_64-linux";
  };
  users.${username} = {
    # Home Manager configuration
  };
};
```

### Adding a New Program Module

1. Create `modules/programs/myprogram.nix`
2. Define configuration using `config.unify.modules.myprogram`
3. Use proper module structure with `lib.mkOption`
4. Reference module in host's `modules` list

### Adding Flake Inputs

- For eval-time: Add to inputs, follow `nix-proxy-flake/nixpkgs` where applicable
- For build-time only: Add `buildTime = true;` and `flake = false;` (e.g., plugins)

### Theme Integration

- Catppuccin is system-wide; use `config.catppuccin` options in modules
- Wallpaper is in `modules/theme/wallpaper.jpg`

## Key Technologies

- **Package Manager**: Nix with flakes
- **System Builder**: nh (Nix Helper)
- **Task Runner**: just
- **VCS**: Git + Jujutsu (jj)
- **Shell**: Fish with modern CLI tools (eza, bat, fzf, zoxide, atuin)
- **Editor**: Neovim via nixCats
- **Desktop**: Hyprland (Wayland compositor) with hyprlock, hyprpanel, rofi
- **Theme**: Catppuccin
- **Containers**: Podman
- **Formatting**: treefmt with multiple formatters

## Code Style Guidelines

- **Indentation**: 2 spaces for all files
- **Line endings**: LF (Unix)
- **Encoding**: UTF-8
- **Final newline**: Required
- **Trailing whitespace**: Trimmed
- **Nix**: Use nixfmt, deadnix, statix
- **Lua**: stylua (2 spaces, always call parentheses, collapse simple statements)
- **Other**: prettier with editorconfig, actionlint for workflows
- **Shell**: shellcheck and shfmt
- **TOML**: taplo
- **Pre-commit**: editorconfig-checker, trim whitespace, gitleaks

## Conventions

- Use `inherit` for common imports in Nix
- Follow existing module structure patterns (see `modules/programs/` for examples)
- Minimal comments - code should be self-documenting
- Use `lib.mkOption` for options with proper types and descriptions
- Keep host definitions in `hosts/${hostname}/${hostname}.nix`
- Hardware-specific configs go in `hosts/${hostname}/_filesystem.nix` or use facter
- WSL-specific: Note that `just rebuild` copies wezterm config to Windows
- User info is centralized in `modules/meta/user.nix`
- Split large program configs into subdirectories (e.g., `modules/programs/hyprland/`)
- Secrets should go in `modules/secrets/` (check existing secret management approach)
- For debugging: Toggle `debug = true` in `modules/flake/default.nix` and use REPL

## Special Notes

- **WSL**: After rebuild on nixWSL, wezterm.lua is automatically copied to Windows user directory
- **Neovim**: Managed via nixCats, configuration in `modules/nvim/`, queries in `modules/nvim/queries/`
- **nixos-facter**: Used for hardware detection (see `facter.json` in host directories)
- **CI/CD**: GitHub Actions builds and caches on every push
- **Pre-commit**: Hooks configured in `.pre-commit-config.yaml` run automatically
