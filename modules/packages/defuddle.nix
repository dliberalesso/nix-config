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
          version = "0.18.1";

          src = pkgs.fetchFromGitHub {
            owner = "kepano";
            repo = "defuddle";
            tag = finalAttrs.version;

            # hash = lib.fakeHash;
            hash = "sha256-e/+eigIzpP0g+ZqTeyZnF6mloaY6UeKcMWfqryCcLbM=";
          };

          # npmDepsHash = lib.fakeHash;
          npmDepsHash = "sha256-1NFwhYEGTKpjzCdK/eHK0TWtOEpn67FA+B3QZ11w1Rs=";

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
