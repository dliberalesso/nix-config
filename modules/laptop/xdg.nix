{
  pkgs,
  ...
}:
{
  xdg.portal = {
    enable = true;

    configPackages = [
      pkgs.hyprland
    ];

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
