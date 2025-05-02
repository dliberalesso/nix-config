{
  config,
  ...
}:
let
  inherit (config.hyprde) wallpaper;
in
{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "off";

      preload = [
        "${wallpaper}"
      ];

      splash = false;

      wallpaper = [
        " , ${wallpaper}"
      ];
    };
  };
}
