{
  pins,
  ...
}:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages = { inherit (pkgs) gemini-cli nanocoder specify-cli; };

      overlayAttrs = {
        gemini-cli = pkgs.callPackage ./_gemini-cli.nix {
          src = pins.gemini-cli { inherit pkgs; };
        };

        nanocoder = pkgs.callPackage ./_nanocoder.nix {
          src = pins.nanocoder { inherit pkgs; };
        };

        specify-cli = pkgs.callPackage ./_specify-cli.nix {
          src = pins.specify-cli { inherit pkgs; };
        };
      };
    };

  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        gemini-cli
        nanocoder
        specify-cli
      ];
    };
}
