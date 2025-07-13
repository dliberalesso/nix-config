{
  moduleWithSystem,
  ...
}:
{
  unify.modules.hyprde.home = moduleWithSystem (
    { config }:
    let
      inherit (config.theme) wallpaper;
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
    }
  );
}
