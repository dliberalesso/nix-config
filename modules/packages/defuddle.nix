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
          version = "0.19.6";

          src = pkgs.fetchFromGitHub {
            owner = "kepano";
            repo = "defuddle";
            tag = finalAttrs.version;

            # hash = lib.fakeHash;
            hash = "sha256-PmtS4ryoXapMaA0HAzdBaUl6dzeGnXa0rA0VLdC/VRQ=";
          };

          # npmDepsHash = lib.fakeHash;
          npmDepsHash = "sha256-Tr1GasXqqUEPMt6+fUjBatzymuaVjK49tsCw/ivtXCY=";

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
