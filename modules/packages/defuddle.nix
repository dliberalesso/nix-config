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
          version = "0.19.4";

          src = pkgs.fetchFromGitHub {
            owner = "kepano";
            repo = "defuddle";
            tag = finalAttrs.version;

            # hash = lib.fakeHash;
            hash = "sha256-H6/hZVe5nj6GNv00RMu1tKDRhCTvB7PX5gc70JWh9ik=";
          };

          # npmDepsHash = lib.fakeHash;
          npmDepsHash = "sha256-B5uX7lIfII9nlCHn6d3zchsokpZFOuP1fuRRLJb7g1M=";

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
