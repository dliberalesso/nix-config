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
          ipc = false;

          splash = false;

          wallpaper = [
            {
              monitor = "";
              path = "${wallpaper}";
            }
          ];
        };
      };
    }
  );
}
