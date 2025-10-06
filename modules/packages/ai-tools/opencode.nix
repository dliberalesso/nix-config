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
      src = pins.opencode { inherit pkgs; };
    in
    {
      packages = { inherit (pkgs) opencode; };

      overlayAttrs = {
        opencode = pkgs.opencode.overrideAttrs (oa: {
          version = lib.strings.removePrefix "v" src.version;

          inherit src;

          node_modules = oa.node_modules.overrideAttrs {
            outputHash = "sha256-ZIwhqdwlUO61ZXDwgjvKTJAB312pJG8bfbIHJcjdX1w=";
          };

          meta = oa.meta // {
            sourceProvenance = with lib.sourceTypes; [ fromSource ];
            platforms = [ "x86_64-linux" ];
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
      home.packages = [ pkgs.opencode ];
    };
}
