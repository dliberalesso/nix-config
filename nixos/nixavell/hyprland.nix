{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixos.hyprland;
in
{
  options.nixos.hyprland = {
    enable = lib.mkEnableOption "Enable hyprland config";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      hyprland = {
        enable = true;
        withUWSM = true;
        # xwayland.enable = false;
      };

      hyprlock.enable = true; # brings `hypridle`
    };

    environment.systemPackages = with pkgs; [
      hyprpaper
      hyprsunset
      # simple-bar
    ];

    hardware.brillo.enable = true; # Backlight and Keyboard LED control
    services.upower.enable = true; # Battery and power related modules
    services.gvfs.enable = true; # For network cover art urls to be cached (spotify for example)
  };
}
