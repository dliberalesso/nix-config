{
  pkgs,
  ...
}:
{
  imports = [
    ./common
    ./programs
    ./scripts

    # TODO: Check catppuccin/nix
    ./cursor.nix
    ./gtk-qt.nix

    # ./hyprpanel.nix
  ];

  home = {
    cursor.enable = true;
    gtk_qt.enable = true;
  };



  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };

    waybar = {
      enable = true;
    };
  };

  services.clipse.enable = true;
}
