{
  lib,
  pkgs,
  ...
}:
{
  home-manager.users.dli50 = {
    imports = [
      ./cursor.nix
      ./gtk-qt.nix
      ./hypridle.nix
      ./hyprlock.nix
      ./hyprpanel.nix
      ./hyprpaper.nix
      ./hyprsunset.nix
    ];

    options.hyprde = with lib; {
      wallpaper = mkOption {
        type = types.path;
        default = ../../assets/wallpapers/0052.png;
      };
    };

    config = {
      home.packages = with pkgs; [
        brightnessctl
        playerctl
        wev
        wl-clipboard
      ];

      programs = {
        rofi = {
          enable = true;
          package = pkgs.rofi-wayland;
        };
      };

      services = {
        clipse.enable = true;
        hyprpolkitagent.enable = true;
      };
    };
  };
}
