# Program Modules

## Responsibility

`modules/programs/` configures user-facing programs. Most files are Home Manager modules; a smaller set also touch NixOS for shells, system-level helpers, or external module imports.

## Dependencies

- **Home Manager program modules**: Primary API surface for program configuration
- **`unify`**: Separates global program config from GUI-scoped or system-scoped config
- **`hostConfig`**: Supplies user identity and repository path for editable configs

## Consumers

- **All user profiles**: Receive global `unify.home` program modules
- **GUI hosts**: Also consume `unify.modules.gui.home` program modules such as WezTerm

## Module Structure

- `*.nix` — one program/tool per file (`git`, `fish`, `jujutsu`, `yazi`, `zed`, ...)
- `cli.nix, gui.nix` — small aggregate toggles for trivial programs
- `starship/, wezterm/` — program dirs that carry helper assets beside the Nix module
- `nix-index-database.nix` — external module import bridged into Home/NixOS

## Home vs NixOS Program Boundary

```nix
{
  unify.home.programs.fish.enable = true;

  unify.nixos = { pkgs, ... }: {
    programs.fish.enable = true;
    environment.shells = [ pkgs.fish ];
  };
}
```

## Editable Configs Live Beside the Module

```nix
{
  unify.modules.gui.home = { config, hostConfig, ... }:
  let
    inherit (config.lib.file) mkOutOfStoreSymlink;
    path = "${hostConfig.flakePath}/modules/programs/my-app/config.lua";
  in {
    xdg.configFile."my-app/config.lua".source = mkOutOfStoreSymlink path;
  };
}
```

## Architectural Boundaries

- **NO hardcoded repo paths or identity**: use `hostConfig.flakePath` and `hostConfig.user.*`
- **NO GUI-only config in global `unify.home`**: gate desktop-only apps under `unify.modules.gui.home`

<important if="you are adding a new program module to this layer">
## Adding a New Program Module
1. Create `modules/programs/<program>.nix`
2. Use plain `unify.home.programs.<name>` for simple toggles, or a lambda `unify.home = { pkgs, ... }: { ... };` when you need arguments
3. Add a NixOS half only when the program needs shell registration, services, or system-wide options
4. If the program has editable upstream config, create a subdirectory and link it with `mkOutOfStoreSymlink`
5. Put GUI-only programs behind `unify.modules.gui.home`
</important>
