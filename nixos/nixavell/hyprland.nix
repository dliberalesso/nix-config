{
  config,
  # inputs,
  lib,
  pkgs,
  ...
}:
let
  # hyprlandPkgs = inputs.hyprland.packages.${pkgs.system};
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
        # package = hyprlandPkgs.hyprland;
        # portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
        withUWSM = true;
        # xwayland.enable = false;
      };

      waybar.enable = true;
    };

    # WARNING How are these autostarting?
    environment.systemPackages = with pkgs; [
      dunst
      hyprpaper
      networkmanagerapplet
    ];

    # https://search.nixos.org/options?query=systemd.user.services
    # https://wiki.archlinux.org/title/Systemd/User
    # https://github.com/Vladimir-csp/uwsm/blob/master/example-units/hyprpaper.service:
    systemd.user.services.hyprpaper = {
      enable = true;
      documentation = [ "man:hyprpaper(1)" ];
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      description = "Hyprpaper wallpaper utility for Hyprland";
      serviceConfig = {
        Type = "exec";
        ExecCondition = ''${pkgs.systemd}/lib/systemd/systemd-xdg-autostart-condition "Hyprland" ""'';
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
        Restart = "on-failure";
        Slice = "background-graphical.slice";
      };
    };
  };
}
