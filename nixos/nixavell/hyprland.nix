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
    };

    # WARNING How are these autostarting?
    environment.systemPackages = with pkgs; [
      dunst
      networkmanagerapplet
    ];
  };
}
