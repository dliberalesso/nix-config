{
  unify.modules.hyprde.nixos =
    {
      lib,
      pkgs,
      ...
    }:
    {
      services.greetd = {
        enable = true;

        settings = {
          initial_session = {
            user = "dli50";
            command = "${lib.getExe pkgs.uwsm} start hyprland-uwsm.desktop";
          };

          default_session.command = ''
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
}
