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
          version = "0.16.0";

          src = pkgs.fetchFromGitHub {
            owner = "kepano";
            repo = "defuddle";
            tag = finalAttrs.version;

            # hash = lib.fakeHash;
            hash = "sha256-hRIeiXv7X1d7ICZCWDkswCrxFhnAkbM5wN3OWo8NmBY=";
          };

          # npmDepsHash = lib.fakeHash;
          npmDepsHash = "sha256-vC0NnvQ/xhhZ584iD71m9cW11IzVMPnVrSIZ9Ax2sfY=";

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
