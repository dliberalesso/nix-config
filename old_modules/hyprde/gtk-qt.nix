{
  lib,
  pkgs,
  ...
}:
{
  home-manager.users.dli50 = {
    gtk = {
      enable = true;

      theme = {
        package = lib.mkForce pkgs.gnome-themes-extra;
        name = "Adwaita-dark";
      };

      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };

    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
}
