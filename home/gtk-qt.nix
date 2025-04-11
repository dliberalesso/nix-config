{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.home.gtk_qt;
in
{
  options.home.gtk_qt = {
    enable = lib.mkEnableOption "Enable GTK & QT config";
  };

  config = lib.mkIf cfg.enable {
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

      # font = {
      #   name = "Sans";
      #   size = 11;
      # };
    };

    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };

    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
}
