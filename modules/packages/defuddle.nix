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
          version = "0.15.0";

          src = pkgs.fetchFromGitHub {
            owner = "kepano";
            repo = "defuddle";
            tag = finalAttrs.version;
            hash = "sha256-E0aSRJEr/bPBvxIMo6YWn5qmguDpajKf+XvfsEagcfI=";
          };

          # npmDepsHash = lib.fakeHash;
          npmDepsHash = "sha256-TdA7wP5C0tvb6//ojLb6lwsRiVFIASTjYArxYDNYTjY=";

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
