{
  perSystem =
    {
      lib,
      ...
    }:
    let
      inherit (lib) mkOption types;
    in
    {
      options.theme.wallpaper = mkOption {
        type = types.path;

        readOnly = true;

        # https://unsplash.com/photos/ZqLeQDjY6fY
        # by Tom Gainor
        default = ./wallpaper.jpg;
      };
    };
}
