{
  unify.modules.hyprde.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "rofi-launcher";

          runtimeInputs = builtins.attrValues {
            inherit (pkgs) procps rofi uwsm;
          };

          text = ''
            # check if rofi is already running
            if pidof rofi > /dev/null; then
              pkill rofi
            fi

            rofi -show drun -run-command "uwsm app -- {cmd}"
          '';
        })
      ];

      programs.rofi.enable = true;
    };
}
