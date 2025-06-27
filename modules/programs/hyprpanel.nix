{
  unify.modules.hyprde.home =
    {
      lib,
      pkgs,
      ...
    }:
    let
      name = "catppuccin_mocha";

      reduceWithJq =
        pkgs.runCommand "hyprpanel-reduced-${name}.json"
          {
            nativeBuildInputs = [ pkgs.jq ];
          }
          ''
            jq '. as $original | reduce keys_unsorted[] as $key ({}; setpath($key | split("."); $original[$key]))' ${pkgs.hyprpanel}/share/themes/${name}.json > $out
          '';

      themeSettings = lib.importJSON reduceWithJq;

      scaling = 90;
    in
    {
      programs.hyprpanel = {
        enable = true;

        settings = lib.recursiveUpdate themeSettings {
          bar = {
            clock.format = "%a %d %b  %H:%M";
            launcher.icon = "󱄅";

            workspaces = {
              monitorSpecific = false;
              show_icons = true;
            };
          };

          menus = {
            clock = {
              time.military = true;
              weather.enabled = false;
            };

            dashboard = {
              directories.enabled = false;
              stats.enable_gpu = true;
            };
          };

          theme = {
            inherit name;

            bar.menus = {
              menu = {
                battery = { inherit scaling; };
                bluetooth = { inherit scaling; };
                clock = { inherit scaling; };
                dashboard.confirmation_scaling = scaling;
                dashboard = { inherit scaling; };
                media = { inherit scaling; };
                network = { inherit scaling; };
                notifications = { inherit scaling; };
                power = { inherit scaling; };
                volume = { inherit scaling; };
              };

              popover = { inherit scaling; };
            };

            font.size = "1.1rem";
            notification = { inherit scaling; };
            osd = { inherit scaling; };
            tooltip = { inherit scaling; };
          };

          wallpaper.enable = false;
        };
      };
    };
}
