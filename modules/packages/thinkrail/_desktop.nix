{
  adwaita-icon-theme,
  at-spi2-atk,
  at-spi2-core,
  atk,
  bun,
  bun-bin,
  bun2nix,
  cairo,
  copyDesktopItems,
  fetchurl,
  formatelf,
  gdk-pixbuf,
  git,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  gtk3,
  lib,
  libayatana-appindicator,
  librsvg,
  libsoup_3,
  makeDesktopItem,
  makeWrapper,
  nodejs_22,
  pango,
  ripgrep,
  stdenv,
  thinkrail,
  webkitgtk_4_1,
  xdg-utils,
  zenity,
}:
let
  inherit (thinkrail) version src;

  electrobunCore = fetchurl {
    url = "https://github.com/blackboardsh/electrobun/releases/download/v2.0.5/electrobun-core-linux-x64.tar.gz";
    hash = "sha256-Kd7sjrf4oBf3hvlYFrzMzZH1FOV+oUho5Ll71Akmjog=";
  };

  runtimeLibs = [
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    gdk-pixbuf
    glib
    gtk3
    libayatana-appindicator
    librsvg
    libsoup_3
    pango
    stdenv.cc.cc.lib
    webkitgtk_4_1
  ];

  desktopItem = makeDesktopItem {
    name = "thinkrail";
    desktopName = "ThinkRail";
    comment = "ThinkRail Desktop AI Coding Workspace";
    exec = "thinkrail-desktop %U";
    icon = "thinkrail";
    startupWMClass = "ThinkRail";
    categories = [ "Development" ];
  };
in
stdenv.mkDerivation {
  pname = "thinkrail-desktop";
  inherit version src;

  nativeBuildInputs = [
    bun2nix.hook
    bun
    copyDesktopItems
    formatelf
    makeWrapper
  ];

  buildInputs = runtimeLibs ++ [
    adwaita-icon-theme
    glib-networking
    gsettings-desktop-schemas
  ];

  inherit (thinkrail) bunDeps;

  dontUseBunBuild = true;
  dontUseBunInstall = true;
  dontRunLifecycleScripts = true;
  dontStrip = true;

  desktopItems = [ desktopItem ];

  postPatch = ''
        cat > packages/shared/src/version.ts <<'EOF'
        export const version = "${version}";
        export const channel = "dev";
        export const commit = "344aafcb0b56902e5fc87834059a353d54ca8892";
        export const posthogProjectKey = "";
    EOF
  '';

  preBuild = ''
    mkdir -p apps/desktop/.hutch/devkit
    tar -xzf ${electrobunCore} -C apps/desktop/.hutch/devkit

    # Resolve Electrobun imports offline from the pinned native SDK instead of invoking Hutch.
    rm -rf apps/desktop/node_modules/electrobun node_modules/electrobun
    mkdir -p apps/desktop/node_modules/electrobun
    cp -r apps/desktop/.hutch/devkit/api apps/desktop/node_modules/electrobun/api
    cat > apps/desktop/node_modules/electrobun/package.json <<'EOF'
    {
      "name": "electrobun",
      "version": "2.0.5",
      "type": "module",
      "exports": {
        ".": "./api/sdks/main/index.ts",
        "./main": "./api/sdks/main/index.ts",
        "./bun": "./api/sdks/main/index.ts",
        "./view": "./api/browser/index.ts",
        "./rpc": "./api/sdks/main/entries/rpc.ts"
      }
    }
    EOF
  '';

  buildPhase = ''
    runHook preBuild

    bun build apps/desktop/src/index.ts \
      --target=bun \
      --outfile=apps/desktop/.stage-bun-index.js

    bun build apps/desktop/src/preload.ts \
      --target=browser \
      --format=iife \
      --outfile=apps/desktop/.stage-preload-index.js

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    appDir="$out/libexec/thinkrail-desktop"
    mkdir -p "$appDir/bin" "$appDir/Resources/app/bun" "$appDir/Resources/app/views/preload" "$out/bin"

    install -Dm755 apps/desktop/.hutch/devkit/launcher "$appDir/bin/launcher"
    install -Dm755 apps/desktop/.hutch/devkit/bspatch "$appDir/bin/bspatch"
    install -Dm755 apps/desktop/.hutch/devkit/zig-zstd "$appDir/bin/zig-zstd"
    install -Dm755 apps/desktop/.hutch/devkit/libElectrobunCore.so "$appDir/bin/libElectrobunCore.so"
    install -Dm755 apps/desktop/.hutch/devkit/libNativeWrapper.so "$appDir/bin/libNativeWrapper.so"
    install -Dm755 apps/desktop/.hutch/devkit/libasar.so "$appDir/bin/libasar.so"
    install -Dm755 ${bun-bin}/share/bun-bin/${bun-bin.target} "$appDir/bin/bun"

    install -Dm644 apps/desktop/.hutch/devkit/main.js "$appDir/Resources/main.js"
    install -Dm644 apps/desktop/.hutch/devkit/preload-full.js "$appDir/Resources/preload-full.js"
    install -Dm644 apps/desktop/.hutch/devkit/preload-sandboxed.js "$appDir/Resources/preload-sandboxed.js"
    install -Dm644 packages/shared/assets/icon.png "$appDir/Resources/app/icon.png"
    install -Dm644 packages/shared/assets/icon.png "$appDir/Resources/appIcon.png"
    install -Dm644 packages/shared/assets/icon.png "$out/share/icons/hicolor/512x512/apps/thinkrail.png"

    install -Dm644 apps/desktop/.stage-bun-index.js "$appDir/Resources/app/bun/index.js"
    install -Dm644 apps/desktop/.stage-preload-index.js "$appDir/Resources/app/views/preload/index.js"
    cp -r ${thinkrail}/share/thinkrail/web "$appDir/Resources/app/views/web"
    cp -r ${thinkrail}/share/thinkrail/runtime "$appDir/Resources/app/runtime"

    cat > "$appDir/Resources/build.json" <<EOF
    {
      "mainProcess": "bun",
      "electrobunVersion": "2.0.5",
      "runtimeVersions": { "bun": "${bun-bin.version}" },
      "defaultRenderer": "native",
      "availableRenderers": ["native"],
      "buildEnvironment": "dev",
      "runtime": { "exitOnLastWindowClosed": true }
    }
    EOF

    cat > "$appDir/Resources/version.json" <<EOF
    {
      "version": "${version}",
      "hash": "nix000000000",
      "channel": "dev",
      "baseUrl": "",
      "name": "ThinkRail",
      "displayName": "ThinkRail",
      "identifier": "ai.thinkrail.app"
    }
    EOF

    makeWrapper "$appDir/bin/launcher" "$out/bin/thinkrail-desktop" \
      --prefix LD_LIBRARY_PATH : "$appDir/bin:${lib.makeLibraryPath runtimeLibs}" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:${adwaita-icon-theme}/share:$out/share" \
      --prefix PATH : "${
        lib.makeBinPath [
          git
          nodejs_22
          ripgrep
          xdg-utils
          zenity
        ]
      }"

    runHook postInstall
  '';

  meta = {
    description = "ThinkRail native desktop application (Electrobun)";
    homepage = "https://thinkrail.ai/";
    changelog = "https://github.com/JetBrains/thinkrail/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "thinkrail-desktop";
    platforms = [ "x86_64-linux" ];
  };
}
