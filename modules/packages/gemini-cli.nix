{
  perSystem =
    {
      pkgs,
      ...
    }:
    let
      version = "0.4.1";
      hash = "sha256-SfZxs7PmVWK1elWKvLDiJRoadV5l6Xtsj70NKfuBsXg=";
    in
    {
      overlayAttrs = {
        gemini-cli-bin = pkgs.gemini-cli-bin.overrideAttrs (_oa: {
          inherit version;

          src = pkgs.fetchurl {
            inherit hash;

            url = "https://github.com/google-gemini/gemini-cli/releases/download/v${version}/gemini.js";
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
      home.packages = [ pkgs.gemini-cli-bin ];
    };
}
