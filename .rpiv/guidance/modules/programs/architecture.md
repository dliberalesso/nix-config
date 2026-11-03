# Program Modules

## Responsibility

`modules/programs/` configures user applications, CLI tools, and development utilities. It binds Home Manager program configurations to system shells and desktop environments.

## Dependencies

- **Home Manager `programs.*`**: Primary API for application settings and dotfile generation
- **`unify`**: Module targeting across global (`unify.home`), system (`unify.nixos`), and GUI scopes
- **`hostConfig`**: Supplies host paths (`flakePath`) and user identity for live-editable config links

## Consumers

- **All hosts & users**: Inherit global CLI utilities (`git`, `zsh`, `bat`, `eza`, `fzf`)
- **GUI hosts**: Receive graphical applications and editors under `unify.modules.gui.home`

## Module Structure

- `*.nix` — single-program configurations (`git.nix`, `zsh.nix`, `atuin.nix`, `yazi.nix`)
- `cli.nix, gui.nix` — bulk toggles for simple CLI utilities and desktop apps
- `wezterm/` — program module with companion external script (`wezterm.lua`)
- `nix-index-database.nix` — third-party flake module integration

## Home vs NixOS Dual-Scope Configuration

```nix
{
  unify.home =
    { config, ... }:
    {
      programs.zsh = {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh";
      };
    };

  unify.nixos =
    { pkgs, ... }:
    {
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
    };
}
```

## Out-of-Store Symlink for Rapid Iteration (`mkOutOfStoreSymlink`)

```nix
{
  unify.modules.gui.home =
    { config, hostConfig, ... }:
    let
      inherit (config.lib.file) mkOutOfStoreSymlink;
      luaConfig = "${hostConfig.flakePath}/modules/programs/wezterm/wezterm.lua";
    in
    {
      programs.wezterm.enable = true;
      xdg.configFile."wezterm/wezterm.lua".source = mkOutOfStoreSymlink luaConfig;
    };
}
```

## Architectural Boundaries

- **NO hardcoded paths or usernames**: always use `hostConfig.flakePath` and `hostConfig.user.*`
- **NO GUI tools in global `unify.home`**: scope graphical programs to `unify.modules.gui.home` (note: `zed.nix` currently resides in global `unify.home` as a legacy anomaly; new GUI applications must follow the `gui.home` convention)
- **KEEP `gui.nix` DESKTOP-AGNOSTIC**: compositor/window manager bindings belong in dedicated desktop session bundles

<important if="you are adding a new program module to this layer">
## Adding a Program Module
1. For trivial CLI tools, enable them in `modules/programs/cli.nix`
2. For dedicated tools, create `modules/programs/<program>.nix`
3. For companion native configs (e.g. `wezterm/`), create `modules/programs/<program>/` containing `<program>.nix` and the native file; wire live edits via `mkOutOfStoreSymlink "${hostConfig.flakePath}/..."`
4. Add a NixOS section only if default shell registration or system daemon integration is required
5. Scope desktop applications under `unify.modules.gui.home`
6. Format with `just fmt` and evaluate/validate with `just lint`
</important>
