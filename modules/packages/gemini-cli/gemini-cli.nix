{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages = { inherit (pkgs) gemini-cli; };

      overlayAttrs.gemini-cli = pkgs.callPackage ./_gemini-cli.nix { };
    };

  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.gemini-cli ];
    };
}
