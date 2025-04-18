{
  inputs,
  ...
}:
{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

  programs.hyprpanel = {
    enable = true;
    overwrite.enable = true;

    settings = {
      bar.clock.format = "%a %d %b  %H:%M";
      bar.launcher.icon = "󱄅";

      menus.clock = {
        time.military = true;
        weather.enabled = false;
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;

      theme.name = "catppuccin_mocha";
      theme.font.size = "1.1rem";

      wallpaper.enable = false;
    };
  };
}
