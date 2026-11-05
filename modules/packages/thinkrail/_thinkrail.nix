{
  bun,
  bun-bin,
  bun2nix,
  fetchFromGitHub,
  formatelf,
  git,
  lib,
  makeWrapper,
  nodejs_22,
  patch,
  ripgrep,
  runCommand,
  stdenv,
  xdg-utils,
}:
let
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = "thinkrail";
    tag = "v${version}";
    hash = "sha256-IHsuRiOy38RtxI989+IMI8JlUnXT31hXbYpy9ZTpirk=";
  };

  patchedDependencies = {
    "@pierre/diffs@1.5.1" = "@pierre%2Fdiffs@1.5.1.patch";
    "@earendil-works/pi-ai@1.4.0" = "@earendil-works%2Fpi-ai@1.4.0.patch";
  };

  bunPackages = import ./_bun.nix {
    fetchFromGitHub = lib.id;
    fetchgit = lib.id;
    fetchurl = lib.id;
  };

  missingPatched = lib.filter (name: !(bunPackages ? ${name})) (lib.attrNames patchedDependencies);
in
stdenv.mkDerivation {
  pname = "thinkrail";
  inherit version src;

  nativeBuildInputs = [
    bun2nix.hook
    bun
    formatelf
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  bunDeps =
    assert lib.assertMsg (
      missingPatched == [ ]
    ) "thinkrail: patched dependencies missing from _bun.nix: ${toString missingPatched}";
    bun2nix.fetchBunDeps {
      bunNix = ./_bun.nix;
      overrides = lib.mapAttrs (
        name: patchFile: pkg:
        runCommand "patched-${lib.strings.sanitizeDerivationName name}" { nativeBuildInputs = [ patch ]; }
          ''
            mkdir -p $out
            cp -r ${pkg}/. $out/
            chmod -R u+w $out
            patch -p1 -d $out < ${src}/patches/${patchFile}
          ''
      ) patchedDependencies;
    };

  dontUseBunBuild = true;
  dontUseBunInstall = true;
  dontRunLifecycleScripts = true;
  dontStrip = true;

  postPatch = ''
        cat > packages/shared/src/version.ts <<'EOF'
        export const version = "${version}";
        export const channel = "dev";
        export const commit = "344aafcb0b56902e5fc87834059a353d54ca8892";
        export const posthogProjectKey = "";
    EOF

        substituteInPlace apps/cli/src/bootstrap.ts \
          --replace-fail \
            $'const exitCode =\n\t\t\tsubcommand === "update"\n\t\t\t\t? await runUpdate(argv.slice(1), process.env, build)\n\t\t\t\t: await runUninstall(argv.slice(1), process.env);\n\t\tprocess.exit(exitCode);' \
            $'console.error("thinkrail is managed by Nix; self-update and uninstall are disabled.");\n\t\tprocess.exit(1);'
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p .bun-tmp .bun-install
    export BUN_TMPDIR=$PWD/.bun-tmp
    export BUN_INSTALL=$PWD/.bun-install
    cp ${bun-bin}/share/bun-bin/* "$BUN_INSTALL_CACHE_DIR"/

    bun apps/desktop/preBuild.ts
    bun apps/cli/scripts/build-binary.ts --target=${bun-bin.target}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 apps/cli/dist/thinkrail-linux-x64-baseline-v${bun-bin.version} $out/libexec/thinkrail/thinkrail
    mkdir -p $out/share/thinkrail
    cp -r apps/web/dist $out/share/thinkrail/web
    cp -r apps/desktop/.stage/runtime $out/share/thinkrail/runtime

    makeWrapper $out/libexec/thinkrail/thinkrail $out/bin/thinkrail \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}" \
      --prefix PATH : "${
        lib.makeBinPath [
          git
          nodejs_22
          ripgrep
          xdg-utils
        ]
      }"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME=$(mktemp -d)
    export XDG_CACHE_HOME=$(mktemp -d)
    test "$($out/bin/thinkrail --version)" = "${version}"
    $out/bin/thinkrail --help | grep -q "Usage:"
    ! $out/bin/thinkrail update 2>/dev/null
    ! $out/bin/thinkrail uninstall 2>/dev/null
    runHook postInstallCheck
  '';

  passthru = {
    inherit src;
  };

  meta = {
    description = "ThinkRail CLI coding agent workspace host";
    homepage = "https://thinkrail.ai/";
    changelog = "https://github.com/JetBrains/thinkrail/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "thinkrail";
    platforms = [ "x86_64-linux" ];
  };
}
