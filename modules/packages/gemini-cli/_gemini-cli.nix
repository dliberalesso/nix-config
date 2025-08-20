{
  lib,
  buildNpmPackage,
  fetchpatch,
  gitUpdater,
  sources,
}:

buildNpmPackage (finalAttrs: {
  pname = "gemini-cli";
  inherit (sources.gemini-cli) version;

  src = sources.gemini-cli // {
    rev = sources.gemini-cli.revision;
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/google-gemini/gemini-cli/pull/5336.patch";
      name = "restore-missing-dependencies-fields.patch";
      hash = "sha256-CfT02RHRSYP8Q8YOdgibqwIj38R8GD6q6gAAoOXBWBc=";
    })
  ];

  npmDepsHash = "sha256-Gh8OAkt+akbKcXINMO6r8LFgNklhiQ5GAf43H/7ReKI=";

  preConfigure = ''
    mkdir -p packages/generated
    echo "export const GIT_COMMIT_INFO = { commitHash: '${finalAttrs.src.rev}' };" > packages/generated/git-commit.ts
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/gemini-cli}

    cp -r node_modules $out/share/gemini-cli/

    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-core
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-test-utils
    rm -f $out/share/gemini-cli/node_modules/gemini-cli-vscode-ide-companion
    cp -r packages/cli $out/share/gemini-cli/node_modules/@google/gemini-cli
    cp -r packages/core $out/share/gemini-cli/node_modules/@google/gemini-cli-core

    ln -s $out/share/gemini-cli/node_modules/@google/gemini-cli/dist/index.js $out/bin/gemini
    runHook postInstall
  '';

  postInstall = ''
    chmod +x "$out/bin/gemini"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "AI agent that brings the power of Gemini directly into your terminal";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "gemini";
  };
})
