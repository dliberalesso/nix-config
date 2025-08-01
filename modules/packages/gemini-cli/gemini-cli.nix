{
  perSystem =
    {
      config,
      pkgs,
      sources,
      ...
    }:
    {
      overlayAttrs = { inherit (config.packages) gemini-cli; };

      packages.gemini-cli = pkgs.callPackage ./_gemini-cli.nix { inherit sources; };
    };

  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = builtins.attrValues {
        inherit (pkgs) gemini-cli;
      };
    };
}
