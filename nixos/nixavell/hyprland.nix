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

      waybar.enable = true;
      hyprlock.enable = true; # brings `hypridle`
    };

    # WARNING How are these autostarting?
    environment.systemPackages = with pkgs; [
      brightnessctl
      dunst
      hyprpaper
      hyprsunset
    ];
  };
}
