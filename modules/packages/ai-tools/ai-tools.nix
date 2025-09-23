{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages = { inherit (pkgs) gemini-cli nanocoder; };

      overlayAttrs = {
        gemini-cli = pkgs.callPackage ./_gemini-cli.nix { };
        nanocoder = pkgs.callPackage ./_nanocoder.nix { };
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
      ];
    };
}
