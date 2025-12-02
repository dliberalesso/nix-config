{
  pins,
  ...
}:
{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      src = pins.nanocoder { inherit pkgs; };
    in
    {
      packages = { inherit (pkgs) nanocoder; };

      overlayAttrs = {
        nanocoder = pkgs.buildNpmPackage (finalAttrs: {
          pname = "nanocoder";
          version = lib.strings.removePrefix "v" src.version;

          inherit src;

          npmConfigHook = pkgs.pnpm.configHook;
          npmDeps = finalAttrs.pnpmDeps;

          pnpmDeps = pkgs.pnpm.fetchDeps {
            inherit (finalAttrs) pname version src;
            fetcherVersion = 2;

            # hash = lib.fakeHash;
            hash = "sha256-9Upw2NT6R3vvGlss5oSZcAIBYTZTySYQF93vsnqn9JU=";
          };

          dontNpmPrune = true; # hangs forever on both Linux/darwin

          postInstall = ''
            # Remove broken symlink to missing vscode plugin
            rm -f $out/lib/node_modules/@nanocollective/nanocoder/node_modules/.pnpm/node_modules/nanocoder-vscode
          '';

          meta = {
            description = "A local-first CLI coding agent that supports various AI providers and features an advanced tool system.";
            homepage = "https://github.com/Nano-Collective/nanocoder";
            changelog = "https://github.com/Nano-Collective/nanocoder/releases";
            license = lib.licenses.mit;
            sourceProvenance = with lib.sourceTypes; [ fromSource ];
            maintainers = [ ];
            platforms = lib.platforms.all;
            mainProgram = "nanocoder";
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
      home.packages = [ pkgs.nanocoder ];
    };
}
