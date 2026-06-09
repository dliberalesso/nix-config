{
  inputs,
  ...
}:
let
  enableCatppuccin = module: {
    ${module} = {
      imports = [ inputs.catppuccin."${module}Modules".catppuccin ];

      catppuccin = {
        enable = true;

        autoEnable = true;
      };
    };
  };
in
{
  unify = (enableCatppuccin "home") // (enableCatppuccin "nixos");
}
