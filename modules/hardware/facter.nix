{
  inputs,
  lib,
  ...
}:
let
  assertPresent = lib.asserts.assertMsg (
    inputs.nixos-facter-modules ? nixosModules
  ) "inputs.nixos-facter-modules doesn't provide nixosModules";
in
lib.optionalAttrs assertPresent {
  unify.modules.facter.nixos =
    {
      config,
      ...
    }:
    let
      inherit (config.networking) hostName;
    in
    {
      imports = [
        inputs.nixos-facter-modules.nixosModules.facter
      ];

      facter.reportPath = ../../hosts/${hostName}/facter.json;
    };
}
