{
  inputs,
  ...
}:
let
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
in
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  inherit catppuccin;

  home-manager.users.dli50 = {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];

    inherit catppuccin;
  };
}
