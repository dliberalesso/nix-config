{
  inputs,
  lib,
  ...
}:
let
  assertPresent = lib.asserts.assertMsg (inputs.nix ? packages) "inputs.nix doesn't provide packages";
in
lib.optionalAttrs assertPresent {
  unify.nixos =
    {
      pkgs,
      ...
    }:
    {
      nix.package = inputs.nix.packages.${pkgs.system}.nix;
    };
}
