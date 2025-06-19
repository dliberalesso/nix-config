{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  unify.options.wallpaper = mkOption {
    type = types.path;

    default = builtins.fetchurl {
      name = "wallpaper-lofi-urban-nightscape.png";
      url = "https://github.com/JaKooLit/Wallpaper-Bank/blob/main/wallpapers/Lofi-Urban-Nightscape.png?raw=true";
      sha256 = "sha256:0mskzjkdxsfcap3rim0qwcx0mikhbirs36xw1p8n18nic88ypwb1";
    };
  };

  unify.modules.hyprde.nixos =
    {
      hostConfig,
      lib,
      ...
    }:
    let
      inherit (lib) mkOption types;
    in
    {
      options.hyprde.wallpaper = mkOption {
        type = types.path;

        default = hostConfig.wallpaper;
      };
    };
}
