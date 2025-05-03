{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./scripts

    ./cursor.nix
    ./fonts.nix
    ./greetd.nix
    ./gtk-qt.nix
    ./hypridle.nix
    ./hyprland.nix
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

  config.home-manager.users.dli50 = {
    home.packages = with pkgs; [
      brightnessctl
      playerctl
      wev
      wl-clipboard
    ];

    home.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };

    services = {
      clipse.enable = true;
      hyprpolkitagent.enable = true;
    };
  };
}
