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
          name = lib.mkForce "Adwaita-dark";
        };

        iconTheme = {
          package = lib.mkForce pkgs.adwaita-icon-theme;
          name = lib.mkForce "Adwaita";
        };
      };
    };
}
