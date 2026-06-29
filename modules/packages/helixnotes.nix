{
  perSystem =
    {
      pkgs,
      ...
    }:
    let
      helixnotes = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "helixnotes";
        version = "1.3.3";

        src = pkgs.fetchFromCodeberg {
          owner = "ArkHost";
          repo = "HelixNotes";
          rev = "v${finalAttrs.version}";

          # hash = lib.fakeHash;
          hash = "sha256-rUTsRoI/LXSFEVaw4rlFjxODd7tCrZTaiKssFly63jQ=";
        };

        # cargoHash = lib.fakeHash;
        cargoHash = "sha256-oPShWgL5DjucCmQgqKbIBaxRwqyWnae52+Hj/YVIqbE=";

        pnpmDeps = pkgs.fetchPnpmDeps {
          inherit (finalAttrs) pname src version;
          fetcherVersion = 3;

          # hash = lib.fakeHash;
          hash = "sha256-0TFLZY9zmRFNHPFJEiU2U8zMqSSPkeCl4bhORAbcdZY=";
        };

        nativeBuildInputs = with pkgs; [
          cargo-tauri.hook

          pnpmConfigHook
          pnpm
          nodejs

          pkg-config
          jq
          moreutils
          wrapGAppsHook3
        ];

        buildInputs = with pkgs; [
          webkitgtk_4_1
          libayatana-appindicator
        ];

        cargoRoot = "src-tauri";
        buildAndTestSubdir = finalAttrs.cargoRoot;

        # Deactivate the upstream update mechanism
        postPatch = ''
          jq '
            .bundle.createUpdaterArtifacts = false |
            .plugins.updater = {"active": false, "pubkey": "", "endpoints": []}
          ' \
          src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
        '';

        meta = with pkgs.lib; {
          description = "HelixNotes desktop application";
          homepage = "https://helixnotes.com/";
          license = licenses.agpl3Plus;
          platforms = platforms.linux;
          mainProgram = "helixnotes";
        };
      });
    in
    {
      overlayAttrs = { inherit helixnotes; };

      packages = { inherit helixnotes; };
    };

  unify.modules.gui.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [ helixnotes ];
    };
}
