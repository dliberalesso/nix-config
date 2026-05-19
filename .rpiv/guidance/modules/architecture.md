# Modules

## Responsibility

`modules/` is the reusable configuration layer. It defines global defaults, opt-in capability modules, package exports, editor/program config, and top-level profiles that hosts compose.

## Dependencies

- **`unify`**: Main architecture boundary for `unify.nixos`, `unify.home`, and `unify.modules.*`
- **`flake-parts`**: Provides `perSystem`, overlays, dev-shell, and flake-module composition
- **Home Manager / NixOS modules**: The two execution targets this tree writes into

## Consumers

- **`hosts/`**: Selects named `config.unify.modules.*` capabilities from this tree
- **`flake.nix`**: Auto-imports this tree through `import-tree`

## Module Structure

- `flake/, meta/, nix/` — flake infrastructure and global metadata/daemon settings
- `system/, hardware/, services/` — reusable machine/system capabilities such as `laptop` and `podman`
- `packages/, programs/, nvim/` — package exports plus user-facing application/editor config
- `theme/` — shared visual system; currently also carries a known `base16` input issue
- `toplevel/` — high-level profiles and cross-layer bundles such as `wsl` and transitional `niride`
- `scripts/` — packaged helper commands exposed through flake outputs or user environments

## Global vs Opt-In Module Boundary

```nix
{
  unify.nixos = { ... }: {
    networking.hostName = hostConfig.name;
  };

  unify.home = { ... }: {
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

- **NO host-specific machine details here**: disks, one-off hardware facts, and VM convenience config stay under `hosts/`
- **NO treat `laptop` as a host alias**: it is a hardware-oriented reusable profile, even if `nixavell` is the only current consumer
- **KNOWN ISSUE**: `modules/theme/scheme.nix` references `inputs.base16.lib`, but `flake.nix` does not currently declare `base16`; fix the input before extending that path

<important if="you are adding a new reusable module to this layer">
## Adding a New Reusable Module
1. Pick the narrowest concern directory (`system/`, `programs/`, `packages/`, `toplevel/`, etc.)
2. Decide whether it is global (`unify.nixos` / `unify.home`) or opt-in (`unify.modules.<name>.*`)
3. Use `hostConfig` for shared host/user metadata instead of hardcoding values
4. If it exports a package, wire both `packages` and `overlayAttrs`
5. Select the new module from a host only after the module itself is reusable
</important>
