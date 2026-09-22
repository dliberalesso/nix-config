# Modules

## Responsibility

`modules/` is the reusable configuration layer. It defines global defaults, opt-in capability modules, package exports, editor/program configs, and top-level profiles that hosts compose.

## Dependencies

- **`unify`**: Main architectural boundary for `unify.nixos`, `unify.home`, and `unify.modules.*`
- **`flake-parts`**: Provides `perSystem`, overlays, dev shells, and flake-module composition
- **Home Manager / NixOS modules**: The primary configuration targets

## Consumers

- **`hosts/`**: Selects named `config.unify.modules.*` capabilities from this tree
- **`flake.nix`**: Auto-imports this tree through `import-tree`

## Module Structure

- `flake/, meta/, nix/` — flake infrastructure, global metadata, and daemon settings
- `system/, hardware/, services/` — reusable machine/system capabilities such as `laptop` and `podman`
- `packages/, programs/, nvim/` — custom package exports plus user application and editor config
- `theme/` — shared Catppuccin visual scheme and wallpaper configuration
- `toplevel/` — high-level profiles and cross-layer bundles such as `wsl` and transitional `niride`
- `scripts/` — packaged helper commands exposed through flake outputs or user environments

## Global vs Opt-In Module Boundary

```nix
{
  unify.nixos = { hostConfig, ... }: {
    networking.hostName = hostConfig.name;
  };

  unify.home = { hostConfig, ... }: {
    home.username = hostConfig.user.username;
  };

  unify.modules.gui.home = { pkgs, ... }: {
    home.packages = [ pkgs.firefox ];
  };
}
```

## Shared Metadata Through `hostConfig`

```nix
{
  config,
  lib,
  ...
}: {
  options.user = lib.mkOption { /* ... */ };

  config.unify.options.user = lib.mkOption {
    internal = true;
    default = config.user; # exposed to hostConfig.user downstream
  };
}
```

## Architectural Boundaries

- **NO host-specific machine details here**: disks, one-off hardware facts, and VM convenience configs stay under `hosts/`
- **NO treating `laptop` as a host alias**: it is a hardware-oriented reusable profile, even if `nixavell` is the primary current consumer
- **KEEP `gui.nix` DE-INDEPENDENT**: generic GUI apps stay in `modules/programs/gui.nix` and `modules/packages/gui.nix`; desktop-environment specifics live in dedicated desktop bundles

<important if="you are adding a new reusable module to this layer">
## Adding a New Reusable Module
1. Pick the narrowest concern directory (`system/`, `programs/`, `packages/`, `toplevel/`, etc.)
2. Decide whether it is global (`unify.nixos` / `unify.home`) or opt-in (`unify.modules.<name>.*`)
3. Use `hostConfig` for shared host/user metadata instead of hardcoding values
4. If it exports a package, wire both `packages` and `overlayAttrs`
5. Select the new module from a host only after the module itself is reusable
</important>
