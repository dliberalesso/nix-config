{
  unify.modules.hyprde.home =
    {
      pkgs,
      ...
    }:
    let
      rofi-launcher = pkgs.writeShellApplication {
        name = "rofi-launcher";

        runtimeInputs = builtins.attrValues {
          inherit (pkgs) procps rofi-wayland uwsm;
        };

        text = ''
          # check if rofi is already running
          if pidof rofi > /dev/null; then
            pkill rofi
          fi

          rofi -show drun -run-command "uwsm app -- {cmd}"
        '';

      };
    in
    {
      home.packages = [ rofi-launcher ];

      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
      };
    };
}
