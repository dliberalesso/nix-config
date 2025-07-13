{
  config,
  ...
}:
let
  inherit (config.theme) wallpaper;
in
{
  unify.modules.hyprde.home = {
    services.hyprpaper = {
      enable = true;

      settings = {
        ipc = "off";

        preload = [ "${wallpaper}" ];

        splash = false;

        wallpaper = [ " , ${wallpaper}" ];
      };
    };
  };
}
