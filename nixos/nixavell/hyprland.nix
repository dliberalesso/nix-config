{
  config,
  lib,
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
        withUWSM = true; # recommended for most users
        # xwayland.enable = true; # Xwayland can be disabled.
      };

      # FIXME: Systemd service is broken
      # nm-applet.enable = true;

      waybar.enable = true;
    };
  };
}
