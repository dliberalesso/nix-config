{
  unify.modules.hyprde.home =
    {
      hostConfig,
      ...
    }:
    let
      inherit (hostConfig) wallpaper;
    in
    {
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
