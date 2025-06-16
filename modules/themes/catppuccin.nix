{
  inputs,
  lib,
  ...
}:
let
  assertPresent = lib.asserts.assertMsg (
    inputs.catppuccin ? nixosModules
  ) "inputs.catppuccin doesn't provide nixosModules";
in
lib.optionalAttrs assertPresent {
  unify =
    let
      enableCatppuccin = module: {
        ${module} = {
          imports = [ inputs.catppuccin."${module}Modules".catppuccin ];

          catppuccin.enable = true;
        };
      };
    in
    (enableCatppuccin "home") // (enableCatppuccin "nixos");
}
