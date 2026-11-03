# Modules

## Responsibility

`modules/` is the reusable configuration layer. It defines global defaults, opt-in capability bundles, package exports, editor/program setups, and top-level environment profiles composed by hosts.

## Dependencies

- **`unify`**: Core framework for global baselines (`unify.nixos`, `unify.home`) and opt-in bundles (`unify.modules.<profile>.*`)
- **`flake-parts`**: Composition engine providing `perSystem`, package overlays, and devshells
- **Home Manager / NixOS**: Target modules for userland and system services

## Consumers

- **`hosts/`**: Composes named `config.unify.modules.*` capabilities into concrete systems
- **`flake.nix`**: Discovers all non-underscored Nix files recursively via `import-tree`

## Module Structure

- `flake/, meta/, nix/` — flake infrastructure, shared metadata, and daemon defaults
- `system/, hardware/, services/` — reusable machine/hardware capabilities (`laptop`, `facter`, `podman`)
- `packages/, programs/, nvim/` — package derivations, user tools, and editor configuration
- `theme/` — Catppuccin color scheme, GTK/Qt styling, and visual tokens
- `toplevel/` — high-level profiles (`wsl`, `niride`) and cross-cutting account baselines
- `scripts/` — packaged standalone shell helpers (e.g. `lazymoji`)

## Global vs Opt-In Module Boundary

```nix
{
  # Global: unconditionally applies to all hosts
  unify.nixos = { hostConfig, ... }: {
    networking.hostName = hostConfig.name;
  };

  # Opt-in capability: applies only when selected by host
  unify.modules.gui.home = { pkgs, ... }: {
    home.packages = [ pkgs.google-chrome ];
  };
}
```

## Shared Metadata Reflection (`hostConfig`)

```nix
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
  name = "Douglas Liberalesso";
  username = "dli50";
in
{
  options.user = mkOption {
    type = types.attrsOf types.str;
    default = { inherit name username; };
  };

  # Expose global option as hostConfig down to all unify modules
  config.unify.options.user = mkOption {
    type = types.attrsOf types.str;
    internal = true;
    default = config.user;
  };
}
```

## Architectural Boundaries

- **NO host-specific machine details here**: disks, partition layouts, and facter dumps stay in `hosts/`
- **TREAT profiles as capabilities, not host aliases**: `laptop` is a hardware capability, not an alias for `nixavell`
- **KEEP `gui.nix` DESKTOP-AGNOSTIC**: desktop applications live in `gui`; compositor specifics live in session profiles

<important if="you are adding a new reusable module to this layer">
## Adding a New Reusable Module
1. Choose the narrowest concern directory (`system/`, `programs/`, `packages/`, etc.)
2. Choose activation scope: global (`unify.nixos`/`unify.home`) or opt-in (`unify.modules.<name>.*`)
3. Access shared identity via `hostConfig.user` rather than hardcoding usernames
4. When exporting packages, export both `packages.<name>` and `overlayAttrs.<name>` in `perSystem`
5. Test against a host by selecting the new capability in `hosts/<host>/<host>.nix`
</important>
