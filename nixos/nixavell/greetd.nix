{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixos.greetd;
in
{
  options.nixos.greetd = {
    enable = lib.mkEnableOption "Enable greetd config";
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          user = "dli50";
          command = "${lib.getExe pkgs.uwsm} start hyprland-uwsm.desktop";
        };
        default_session = {
          command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --remember \
            --asterisks \
            --sessions "${pkgs.hyprland}/share/wayland-sessions" \
            --cmd "${lib.getExe pkgs.uwsm} start hyprland-uwsm.desktop"
          '';
        };
      };
    };
  };
}
