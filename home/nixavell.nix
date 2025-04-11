{
  pkgs,
  ...
}:
{
  imports = [
    ./common
    ./programs/spicetify.nix
    ./scripts

    ./cursor.nix
    ./gtk-qt.nix
  ];

  home = {
    cursor.enable = true;
    gtk_qt.enable = true;
  };

  home.packages = with pkgs; [
    kdePackages.kcalc

    wezterm

    google-chrome

    prismlauncher
    obsidian
  ];

  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
  };
}
