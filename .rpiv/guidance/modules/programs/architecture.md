# Program Modules

## Responsibility

`modules/programs/` configures user-facing applications and CLI utilities. Most files are Home Manager modules, with paired NixOS modules where shells, system-level helpers, or external modules are required.

## Dependencies

- **Home Manager program modules**: Primary API surface for user-space program configuration
- **`unify`**: Distributes program config across global (`unify.home`), system (`unify.nixos`), and GUI (`unify.modules.gui.home`) scopes
- **`hostConfig`**: Supplies user identity and repository path for out-of-store editable symlinks

## Consumers

- **All user profiles**: Receive global `unify.home` program modules
- **GUI hosts**: Also consume `unify.modules.gui.home` program modules such as WezTerm and Zed

## Module Structure

- `*.nix` — one program per file (`git`, `fish`, `jujutsu`, `yazi`, `zed`, `bat`, `eza`, ...)
- `cli.nix, gui.nix` — aggregate toggles for simple CLI and GUI apps
- `starship/, wezterm/` — program directories that carry helper scripts or Lua assets beside the Nix module
- `nix-index-database.nix` — external flake module integrated into Home/NixOS

## Home vs NixOS Dual-Scope Configuration

```nix
{
  unify.home.programs.fish.enable = true;

  unify.nixos = { pkgs, ... }: {
    programs.fish.enable = true;
    environment.shells = [ pkgs.fish ];
    users.defaultUserShell = pkgs.fish;
  };
}
```

## GUI-Scoped Out-of-Store Symlink (`mkOutOfStoreSymlink`)

```nix
{
  unify.modules.gui.home = { config, hostConfig, ... }:
  let
    inherit (config.lib.file) mkOutOfStoreSymlink;
    path = "${hostConfig.flakePath}/modules/programs/wezterm/wezterm.lua";
  in {
    programs.wezterm.enable = true;
    xdg.configFile."wezterm/wezterm.lua".source = mkOutOfStoreSymlink path;
  };
}
```

## Architectural Boundaries

- **NO hardcoded repository paths or user names**: use `hostConfig.flakePath` and `hostConfig.user.*`
- **NO GUI-only apps in global `unify.home`**: gate desktop-only applications under `unify.modules.gui.home`
- **KEEP `gui.nix` DESKTOP-AGNOSTIC**: `modules/programs/gui.nix` houses general desktop apps; compositor/DE-specific modules belong in dedicated desktop modules

<important if="you are adding a new program module to this layer">
## Adding a New Program Module
1. For trivial CLI tools, add `unify.home.programs.<name>.enable = true;` to `cli.nix`
2. For dedicated tools, create `modules/programs/<program>.nix`
3. Add a NixOS block only when shell registration, system packages, or daemon options are needed
4. For GUI tools, scope under `unify.modules.gui.home` and link live configs with `mkOutOfStoreSymlink`
</important>
