# Package Modules

## Responsibility

`modules/packages/` provisions software: it gathers existing packages into declarative install sets, wraps complex applications, and compiles custom derivations exported through flake outputs and overlays.

## Dependencies

- **`flake-parts` (`perSystem`)**: Derivation export boundary for `packages` and `overlayAttrs`
- **Nixpkgs builders**: `stdenvNoCC`, `callPackage`, `writeShellApplication`, `overrideAttrs`
- **`unify`**: Scope assignment across global (`unify.home`), system (`unify.nixos`), or named profiles

## Consumers

- **All configuration modules**: Access custom packages through `pkgs.<name>` via `overlayAttrs`
- **Hosts**: Select profile packages (e.g. `unify.modules.gui.home`, `unify.modules.wsl.home`)

## Module Structure

- `cli.nix, gui.nix, fonts.nix` — declarative package collections for common roles
- `*.nix` — standalone custom packages and wrapper definitions
- `<pkg>/<pkg>.nix` — public flake module exposing a package
- `<pkg>/_<pkg>.nix` — private derivation implementation (excluded from auto-import)
- `espanso/` — custom derivation with privileged Linux capability wrapper

## Dual Package Export (`packages` + `overlayAttrs`)

```nix
{
  perSystem =
    { pkgs, ... }:
    let
      my-tool = pkgs.writeShellApplication {
        name = "my-tool";
        text = ''echo "hello"'';
      };
    in
    {
      overlayAttrs = { inherit my-tool; }; # exposes tool to pkgs.my-tool everywhere
      packages = { inherit my-tool; }; # exposes tool to `nix run .#my-tool`
    };

  unify.home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.my-tool ];
    };
}
```

## Public Flake Module + Private Derivation Split

```nix
# modules/packages/pjeoffice-pro/pjeoffice-pro.nix (auto-discovered)
{
  perSystem =
    { pkgs, ... }:
    let
      pjeoffice-pro = pkgs.callPackage ./_pjeoffice-pro.nix { };
    in
    {
      overlayAttrs = { inherit pjeoffice-pro; };
      packages = { inherit pjeoffice-pro; };
    };
}
```

## Architectural Boundaries

- **REUSABLE PACKAGES EXPORT DUAL OUTPUTS**: standalone `perSystem` derivations must export through BOTH `packages` and `overlayAttrs` so they are accessible everywhere as `pkgs.<name>`
- **SYSTEM-DEPENDENT PACKAGES STAY IN NIXOS MODULES**: derivations requiring system-evaluated configuration (e.g. `espanso` requiring `config.security.wrapperDir`) are instantiated directly inside the NixOS module via `callPackage`, not exported through `perSystem`
- **PRIVILEGED CAPABILITIES IN NIXOS MODULES**: Linux capability grants and wrappers belong in `security.wrappers` inside the public NixOS module, never inside the raw derivation
- **DISTRIBUTED BUNDLE AUGMENTATION IS ALLOWED**: package modules may contribute directly to named bundles (e.g. `unify.modules.wsl.home` or `gui.home`) to keep packaging self-contained

<important if="you are adding a new custom package to this layer">
## Adding a Custom Package
1. Use a flat file `<pkg>.nix` for simple packages; use `<pkg>/<pkg>.nix` + `_<pkg>.nix` for complex ones
2. Build reusable derivations in `perSystem` using standard builders (npm, go, stdenvNoCC)
3. For reusable packages, export to both `packages.<name>` and `overlayAttrs.<name>`; for system-dependent wrappers (e.g. `espanso` needing `config.security.wrapperDir`), instantiate directly inside the NixOS module via `callPackage`
4. Install via `unify.home = { pkgs, ... }: { home.packages = [ pkgs.<name> ]; };` or into a profile bundle
5. Run `just fmt` and build with `nix build .#<name>`
</important>
