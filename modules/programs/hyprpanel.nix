{
  inputs,
  ...
}:
{
  unify.modules.hyprde.nixos = {
    nixpkgs.overlays = [
      inputs.hyprpanel.overlay
    ];
  };

  unify.modules.hyprde.home =
    {
      pkgs,
      ...
    }:
    {
      imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

      home.packages = with pkgs; [
        brightnessctl
        playerctl
      ];

      programs.hyprpanel = {
        enable = true;
        overwrite.enable = true;

        settings = {
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

          theme =
            let
              scaling = 90;
            in
            {
              name = "catppuccin_mocha";
              font.size = "1.1rem";

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

              notification = { inherit scaling; };
              osd = { inherit scaling; };
              tooltip = { inherit scaling; };
            };

          wallpaper.enable = false;
        };
      };
    };
}
