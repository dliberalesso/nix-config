{
  copyDesktopItems,
  fetchzip,
  jdk,
  lib,
  makeDesktopItem,
  makeWrapper,
  stdenvNoCC,
  unzip,
  writeScript,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pjeoffice-pro";
  version = "2.5.16u";

  src = fetchzip {
    url = "https://pje-office.pje.jus.br/pro/pjeoffice-pro-v${finalAttrs.version}-linux_x64.zip";
    hash = "sha256-R6XTJ5PrlPYfreMdd6dlhe1pq0YgkEOYUDJAxJHDE1s=";
  };

  passthru.updateScript = writeScript "update-irpf" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts

    set -eu -o pipefail

    version="$(curl -s https://pjeoffice.trf3.jus.br/pjeoffice-pro/docs/userguide.html | grep -oP '(?<=-pro-v).*(?=-linux_x64.zip)')"
    update-source-version pjeoffice-pro "$version"
  '';

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    unzip
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "pjeoffice-pro";
      exec = "pjeoffice-pro";
      icon = "pje-icon-default";
      desktopName = "PJeOffice Pro";
      comment = "Software para acesso ao PJE via certificado digital e assinatura eletrônica de documentos";
      categories = [ "Office" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    BASEDIR="$out/share/pjeoffice-pro"
    mkdir -p "$BASEDIR"

    install -Dm755 ffmpeg.exe "$BASEDIR"

    install -Dm644 cutplayer4jfx.jar pjeoffice-pro.jar pjeoffice-update.properties "$BASEDIR"

    sed -i 's#update.url=https://pje-office.pje.jus.br/pro/#update.url=disabled#' "$BASEDIR/pjeoffice-update.properties"

    # make xdg-open overrideable at runtime
    makeWrapper ${jdk}/bin/java $out/bin/pjeoffice-pro \
      --add-flags "-Dawt.useSystemAAFontSettings=on" \
      --add-flags "-Dswing.aatext=true" \
      --add-flags "-XX:+UseG1GC" \
      --add-flags "-XX:MinHeapFreeRatio=3" \
      --add-flags "-XX:MaxHeapFreeRatio=3" \
      --add-flags "-Xms20m" \
      --add-flags "-Xmx2048m" \
      --add-flags "-Dpjeoffice_home=$BASEDIR" \
      --add-flags "-Dffmpeg_home=$BASEDIR" \
      --add-flags "-Dsigner4j_a3auto=true" \
      --add-flags "-jar $BASEDIR/pjeoffice-pro.jar" \
      --set _JAVA_AWT_WM_NONREPARENTING 1 \
      --set AWT_TOOLKIT MToolkit

    mkdir -p $out/share/icons
    unzip -j pjeoffice-pro.jar images/pje-icon-default.png -d $out/share/icons

    runHook postInstall
  '';

  meta = with lib; {
    description = "Application for access to PJE via digital certificate and for electronic signature of documents.";
    longDescription = ''
      Application for access to PJE via digital certificate and for electronic signature of documents.

      PJeOffice Pro.
    '';
    homepage = "https://pjeoffice.trf3.jus.br/";
    license = licenses.unfree;
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [
      dliberalesso
    ];
    mainProgram = "pjeoffice-pro";
  };
})
