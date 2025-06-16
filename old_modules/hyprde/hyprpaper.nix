{
  config,
  ...
}:
let
  inherit (config.hyprde) wallpaper;
in
{
  home-manager.users.dli50.services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "off";

      preload = [ "${wallpaper}" ];

      splash = false;

      wallpaper = [ " , ${wallpaper}" ];
    };
  };
}
