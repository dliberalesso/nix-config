{
  pkgs,
  ...
}:
{
  imports = [
    ./common
    ./hyprde
    ./programs
    ./scripts
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";

    fcitx5 = {
      addons = with pkgs; [
        fcitx5-gtk
        kdePackages.fcitx5-qt
      ];

      waylandFrontend = true;
    };
  };
}
