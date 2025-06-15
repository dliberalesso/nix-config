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
    ./rofi.nix
  ];

  options.hyprde = with lib; {
    wallpaper = mkOption {
      type = types.path;
      default = builtins.fetchurl {
        name = "wallpaper-lofi-urban-nightscape.png";
        url = "https://github.com/JaKooLit/Wallpaper-Bank/blob/main/wallpapers/Lofi-Urban-Nightscape.png?raw=true";
        sha256 = "sha256:0mskzjkdxsfcap3rim0qwcx0mikhbirs36xw1p8n18nic88ypwb1";
      };
    };
  };

  config.home-manager.users.dli50 = {
    home.packages = [ pkgs.wl-clipboard ];

    home.sessionVariables.NIXOS_OZONE_WL = "1";

    services = {
      clipse.enable = true;
      hyprpolkitagent.enable = true;
    };
  };
}
