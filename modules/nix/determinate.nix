{
  inputs,
  lib,
  ...
}:
let
  assertPresent = lib.asserts.assertMsg (inputs.nix ? packages) "inputs.nix doesn't provide packages";
in
lib.optionalAttrs assertPresent (
  let
    nixpkgs.overlays = [
      inputs.nix.overlays.default
    ];
  in
  {
    perSystem = { inherit nixpkgs; };

    unify.nixos = { inherit nixpkgs; };
  }
)
