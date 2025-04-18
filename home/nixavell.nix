{
  ...
}:
{
  imports = [
    ./common
    ./hyprde
    ./programs
    ./scripts
  ];

  # TODO: add this to a specialization
  # WARN: don't forget to start it in hyprland.conf
  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #
  #   fcitx5 = {
  #     addons = with pkgs; [
  #       fcitx5-gtk
  #       kdePackages.fcitx5-qt
  #     ];
  #
  #     waylandFrontend = true;
  #   };
  # };
}
