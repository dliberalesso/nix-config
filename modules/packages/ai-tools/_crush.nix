{
  buildGoModule,
  lib,
  src,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "crush";
  version = lib.strings.removePrefix "v" src.version;

  inherit src;

  vendorHash = "sha256-rIffQ+B/hDA+jQja8wxPfuCUS+gdAU7NwvTIFqT+zxo=";

  # rename TestMain to prevent it from running, as it panics in the sandbox.
  postPatch = ''
    substituteInPlace internal/llm/provider/openai_test.go \
      --replace-fail \
        "func TestMain" \
        "func DisabledTestMain"
  '';

  ldflags = [
    "-s"
    "-X=github.com/charmbracelet/crush/internal/version.Version=${finalAttrs.version}"
  ];

  checkFlags =
    let
      # these tests fail in the sandbox
      skippedTests = [
        "TestOpenAIClientStreamChoices"
        "TestGrepWithIgnoreFiles"
        "TestSearchImplementations"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Glamourous AI coding agent for your favourite terminal";
    homepage = "https://github.com/charmbracelet/crush";
    changelog = "https://github.com/charmbracelet/crush/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.fsl11Mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "crush";
  };
})
