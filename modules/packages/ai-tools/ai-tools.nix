{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages = { inherit (pkgs) gemini-cli nanocoder specify-cli; };

      overlayAttrs = {
        gemini-cli = pkgs.callPackage ./_gemini-cli.nix { };
        nanocoder = pkgs.callPackage ./_nanocoder.nix { };
        specify-cli = pkgs.callPackage ./_specify-cli.nix { };
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
