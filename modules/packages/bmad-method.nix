{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      bmad-method = pkgs.buildNpmPackage (finalAttrs: {
        pname = "bmad-method";
        version = "6.6.0";

        src = pkgs.fetchFromGitHub {
          owner = "bmad-code-org";
          repo = "BMAD-METHOD";
          tag = "v${finalAttrs.version}";
          # hash = lib.fakeHash;
          hash = "sha256-Fbuxi7F3XLjyuce3NsfQ3Zmo+EcWDXT+kiN4BmSxzv0=";
        };

        # npmDepsHash = lib.fakeHash;
        npmDepsHash = "sha256-PYqnN9qpsgZ7g77qVtrArM5LucK3BuslakX8ndqZkGk=";

        dontNpmBuild = true;
        npmPrune = false;

        nativeBuildInputs = [ pkgs.makeWrapper ];

        postInstall = ''
          wrapProgram $out/bin/bmad-method \
            --set NODE_PATH "$out/lib/node_modules/bmad-method" \
            --prefix PATH : ${lib.makeBinPath [ pkgs.nodejs ]}

          if [ -f "$out/bin/bmad" ]; then
            wrapProgram $out/bin/bmad \
              --set NODE_PATH "$out/lib/node_modules/bmad-method" \
              --prefix PATH : ${lib.makeBinPath [ pkgs.nodejs ]}
          fi
        '';

        meta = {
          description = "Universal AI Agent Framework for AI-assisted development";
          homepage = "https://github.com/bmadcode/BMAD-METHOD";
          license = lib.licenses.mit;
          mainProgram = "bmad-method";
          platforms = lib.platforms.all;
        };
      });
    in
    {
      overlayAttrs = { inherit bmad-method; };

      packages = { inherit bmad-method; };
    };

  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        bmad-method
      ];
    };
}
