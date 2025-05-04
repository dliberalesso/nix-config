{
  inputs,
  ...
}:
let
  catppuccin = {
    enable = true;
    cache.enable = true;
  };
in
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  inherit catppuccin;

  home-manager.users.dli50 = {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];

    catppuccin = catppuccin // {
      mako.enable = false;
    };
  };
}
