# Package Modules

## Responsibility

`modules/packages/` provisions software. It either installs existing packages into Home/NixOS profiles or defines custom packages that are exported as flake packages and overlays.

## Dependencies

- **`perSystem` / overlays**: Custom packages are exposed through `packages` and `overlayAttrs`
- **Nixpkgs builders**: `buildNpmPackage`, `stdenvNoCC`, `callPackage`, and `overrideAttrs` shape implementation here
- **`unify`**: Chooses whether packages are global, GUI-scoped, work-scoped, or system-only

## Consumers

- **Other modules**: Install exported packages as `pkgs.<name>` after overlay wiring
- **Hosts**: Indirectly consume profile-scoped package modules such as `gui`, `work`, and `irpf`

## Module Structure

- `cli.nix, gui.nix, fonts.nix` — package aggregators for common install sets
- `*.nix` — single custom package modules exposed through flake outputs and/or installs
- `<pkg>/<pkg>.nix` — public wrapper module for a complex package
- `<pkg>/_*.nix` — private derivation details
- `espanso/` — special case where packaging and NixOS capability wrapper are both required

## Export Then Consume Through `pkgs`

```nix
{
  perSystem = { pkgs, ... }:
  let my-tool = pkgs.buildNpmPackage { /* ... */ }; in {
    overlayAttrs = { inherit my-tool; };
    packages = { inherit my-tool; };
  };

  unify.home = { pkgs, ... }: {
    home.packages = [ pkgs.my-tool ];
  };
}
```

## Public Wrapper + Private Derivation Split

```nix
# modules/packages/example/example.nix
let example = pkgs.callPackage ./_example.nix { }; in {
  packages = { inherit example; };
}

# modules/packages/example/_example.nix
stdenvNoCC.mkDerivation {
  pname = "example";
  installPhase = ''makeWrapper ...'';
}
```

## Architectural Boundaries

- **NO direct use of a custom package before overlay export**: if later code expects `pkgs.<name>`, export it via `overlayAttrs`
- **KEEP privileged runtime concerns in NixOS modules**: the `espanso` capability wrapper belongs in the public NixOS module, not only inside the derivation

<important if="you are adding a new custom package to this layer">
## Adding a New Custom Package
1. Use a flat file for simple packages; use `<name>/<name>.nix` + `_<name>.nix` for complex ones
2. Build in `perSystem`
3. Export through both `packages` and `overlayAttrs`
4. Install via `pkgs.<name>` from `unify.home`, `unify.nixos`, or `unify.modules.<profile>.*`
5. If Linux capabilities or wrappers are required, keep that system policy in the NixOS module layer beside the package
</important>
