{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixos.xdg;
in
{
  options.nixos.xdg = {
    enable = lib.mkEnableOption "Enable xdg-portal config";
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;

      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      configPackages = [ pkgs.hyprland ];
    };
  };
}
