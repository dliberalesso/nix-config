{
  perSystem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      overlayAttrs = { inherit (config.packages) defuddle; };

      packages = {
        defuddle = pkgs.buildNpmPackage (finalAttrs: {
          pname = "defuddle";
          version = "0.19.13";

          src = pkgs.fetchFromGitHub {
            owner = "kepano";
            repo = "defuddle";
            tag = finalAttrs.version;

            # hash = lib.fakeHash;
            hash = "sha256-8Y2EJdttRZQBsalUjmpWPxkq9JmRbShhsauD3j8x7/g=";
          };

          # npmDepsHash = lib.fakeHash;
          npmDepsHash = "sha256-yHBpI9+RIjv5wB20JznNlrKFxLa5d8Bm8CqTuSTfv0Y=";

          meta = {
            description = "Extract clean html, markdown and metadata from web pages";
            homepage = "https://github.com/kepano/defuddle";
            license = lib.licenses.mit;
            mainProgram = "defuddle";
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
      home.packages = [ pkgs.defuddle ];
    };
}
