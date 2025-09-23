{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  pnpm,
}:

buildNpmPackage (finalAttrs: {
  pname = "nanocoder";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "Nano-Collective";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fSboZwmBKqyriMy4iEAWquzrVTI9sUiQpxqGvRfquEY=";
    postFetch = ''
      rm -f $out/pnpm-workspace.yaml
    '';
  };

  npmConfigHook = pnpm.configHook;
  npmDeps = finalAttrs.pnpmDeps;

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-WVf2Fnp5+fDfxcqdyeQt3gyeoDxYbPQGrUpyOCXRXs0=";
  };

  dontNpmPrune = true; # hangs forever on both Linux/darwin

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
})
