{
  inputs,
  ...
}:
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  catppuccin.enable = true;

  home-manager.users.dli50 = {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];

    catppuccin.enable = true;
  };
}
