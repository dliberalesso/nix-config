{
  config,
  inputs,
  lib,
  ...
}:
let
  hostName = "nixavell";

  args = import ../_args.nix hostName;

  assertPresent = lib.asserts.assertMsg (
    inputs.nixos-facter-modules ? nixosModules
  ) "inputs.nixos-facter-modules doesn't provide nixosModules";

  facterConfig = lib.optionalAttrs assertPresent {
    unify.hosts.nixos.${hostName}.nixos = {
      imports = [
        inputs.nixos-facter-modules.nixosModules.facter
      ];

      facter.reportPath = ./facter.json;
    };
  };

  inherit (config) unify;
in
{
  imports = [
    args
    facterConfig
  ];

  unify.hosts.nixos.${hostName} =
    {
      config,
      ...
    }:
    {
      modules = builtins.attrValues {
        inherit (unify.modules) gui;
      };

      nixos = {
        imports = [
          ../../old_modules/hyprde
          ../../old_modules/laptop
        ];
      };

      users.${config.user.username} = {
        modules =
          config.modules
          ++ builtins.attrValues {
            inherit (unify.modules) irpf;
          };
      };
    };
}
