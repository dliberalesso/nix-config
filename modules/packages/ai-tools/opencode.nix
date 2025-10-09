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
            outputHash = "sha256-p01odCHK8++numXipx1p9qJ+bvZuGjBnV9GZRg0iQLY=";
          };

          tui = oa.tui.overrideAttrs {
            vendorHash = "sha256-g3+2q7yRaM6BgIs5oIXz/u7B84ZMMjnxXpvFpqDePU4=";
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
