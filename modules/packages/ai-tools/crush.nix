{
  pins,
  ...
}:
{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      src = pins.crush { inherit pkgs; };
    in
    {
      packages = { inherit (pkgs) crush; };

      overlayAttrs = {
        crush = pkgs.crush.overrideAttrs (oa: {
          version = lib.strings.removePrefix "v" src.version;

          inherit src;

          vendorHash = "sha256-rIffQ+B/hDA+jQja8wxPfuCUS+gdAU7NwvTIFqT+zxo=";

          meta = oa.meta // {
            sourceProvenance = with lib.sourceTypes; [ fromSource ];
            platforms = lib.platforms.all;
          };
        });
      };
    };

  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.crush ];
    };
}
