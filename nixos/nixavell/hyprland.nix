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
      brightnessctl
      dunst
      hyprpaper
      hyprsunset
      simple-bar
    ];
  };
}
