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
        version = "6.7.1";

        src = pkgs.fetchFromGitHub {
          owner = "bmad-code-org";
          repo = "BMAD-METHOD";
          tag = "v${finalAttrs.version}";
          # hash = lib.fakeHash;
          hash = "sha256-U1qBhz/qqUQ9edt1mLDfo8QHPNrAk9q6AVy3zC5FuSs=";
        };

        # npmDepsHash = lib.fakeHash;
        npmDepsHash = "sha256-wW5rpoRNOufzg2d/Tqzh7gGgZKR4Hucz47dSkJlIwgE=";

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
