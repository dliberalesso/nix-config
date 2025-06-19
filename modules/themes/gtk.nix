{
  unify.modules.gui.home =
    {
      lib,
      pkgs,
      ...
    }:
    {
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
    };
}
