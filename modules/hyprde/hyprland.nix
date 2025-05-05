{
  pkgs,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # xwayland.enable = false;
  };

  xdg.portal = {
    enable = true;

    configPackages = [ pkgs.hyprland ];

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  home-manager.users.dli50.home.packages = [ pkgs.wev ];
}
