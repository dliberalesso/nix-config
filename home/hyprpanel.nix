{
  inputs,
  ...
}:
{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

  programs.hyprpanel = {
    enable = true;

    # Fix the overwrite issue with HyprPanel.
    # See below for more information.
    # Default: false
    overwrite.enable = true;

    # Override the final config with an arbitrary set.
    # Useful for overriding colors in your selected theme.
    # Default: {}
    # override = {
    #   theme.bar.menus.text = "#123ABC";
    # };

    # Configure bar layouts for monitors.
    # See 'https://hyprpanel.com/configuration/panel.html'.
    # Default: null
    # layout = {
    #   "bar.layouts" = {
    #     "0" = {
    #       left = [ "dashboard" "workspaces" ];
    #       middle = [ "media" ];
    #       right = [ "volume" "systray" "notifications" ];
    #     };
    #   };
    # };

    # Configure and theme almost all options from the GUI.
    # Options that require '{}' or '[]' are not yet implemented,
    # except for the layout above.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {
      bar.clock.format = "%a %d %b  %H:%M";
      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;

      menus.clock = {
        time.military = true;
        weather.enabled = false;
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;

      theme.name = "catppuccin_mocha";
      theme.font = {
        #   name = "CaskaydiaCove NF";
        size = "1.1rem";
      };

      wallpaper.enable = false;
    };
  };
}
