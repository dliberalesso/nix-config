{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      overlayAttrs = {
        libratbag = pkgs.libratbag.overrideAttrs (_: {
          patches = [
            ./g502-x-plus-wireless.patch
          ];
        });
      };
    };
}
