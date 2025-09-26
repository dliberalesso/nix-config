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
      packages = {
        inherit (pkgs)
          crush
          gemini-cli
          nanocoder
          specify-cli
          ;
      };

      overlayAttrs = {
        crush = pkgs.callPackage ./_crush.nix {
          src = pins.crush { inherit pkgs; };
        };

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
        crush
        gemini-cli
        nanocoder
        specify-cli
      ];
    };
}
