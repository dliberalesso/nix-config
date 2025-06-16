{
  inputs,
  lib,
  ...
}:
let
  assertPresent = lib.asserts.assertMsg (
    inputs.nix-index-database ? nixosModules
  ) "inputs.nix-index-database doesn't provide nixosModules";
in
lib.optionalAttrs assertPresent {
  unify.home = {
    imports = [
      inputs.nix-index-database.hmModules.nix-index
    ];

    programs = {
      nix-index-database.comma.enable = true;
      nix-index.enable = true;
    };
  };

  unify.nixos = {
    imports = [
      inputs.nix-index-database.nixosModules.nix-index
    ];
  };
}
