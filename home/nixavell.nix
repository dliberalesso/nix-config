{
  pkgs,
  ...
}:
{
  imports = [
    ./common
    ./programs/spicetify.nix
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

    waybar = {
      enable = true;
    };
  };

  services.clipse.enable = true;
}
