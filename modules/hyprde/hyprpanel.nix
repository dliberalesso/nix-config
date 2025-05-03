{
  inputs,
  ...
}:
{
  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true; # Battery and power related modules
    gvfs.enable = true; # For network cover art urls to be cached (spotify for example)
  };

  home-manager.users.dli50 = {
    imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

    programs.hyprpanel = {
      enable = true;
      overwrite.enable = true;

      settings = {
        bar = {
          clock.format = "%a %d %b  %H:%M";
          launcher.icon = "󱄅";
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
          name = "catppuccin_mocha";
          font.size = "1.1rem";
        };

        wallpaper.enable = false;
      };
    };
  };
}
