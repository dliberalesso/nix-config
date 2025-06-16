{
  hm,
  inputs,
  ...
}:
let
  enableCatppuccin = module: {
    imports = [ inputs.catppuccin."${module}Modules".catppuccin ];

    catppuccin.enable = true;
  };
in
(enableCatppuccin "nixos") // hm (enableCatppuccin "home")
