{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  ripgrep,
  pkg-config,
  libsecret,
  git,
}:

buildNpmPackage (finalAttrs: {
  pname = "gemini-cli";
  version = "0.5.0-preview-2";

  src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oA/FTJyalFtelXMajvHCNrfiMV1jg+CurGIXByYXYUA=";
  };

  patches = [
    ./fix-ripgrep.patch
    ./fix-imports.patch
  ];

  npmDepsHash = "sha256-ggOJTubhsljvLg3wNWSIttzqHC6EePazTvXimOkAjRY=";

  nativeBuildInputs = [
    pkg-config
    git
  ];

  buildInputs = [
    ripgrep
    libsecret
  ];

  preConfigure = ''
    git init
    mkdir -p packages/generated
    echo "export const GIT_COMMIT_INFO = { commitHash: '${finalAttrs.src.rev}' };" > packages/generated/git-commit.ts
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/gemini-cli}

    cp -r node_modules $out/share/gemini-cli/

    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-core
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-a2a-server
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-test-utils
    rm -f $out/share/gemini-cli/node_modules/gemini-cli-vscode-ide-companion
    cp -r packages/cli $out/share/gemini-cli/node_modules/@google/gemini-cli
    cp -r packages/core $out/share/gemini-cli/node_modules/@google/gemini-cli-core
    cp -r packages/a2a-server $out/share/gemini-cli/node_modules/@google/gemini-cli-a2a-server

    ln -s $out/share/gemini-cli/node_modules/@google/gemini-cli/dist/index.js $out/bin/gemini
    chmod +x "$out/bin/gemini"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI agent that brings the power of Gemini directly into your terminal";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "gemini";
  };
})
