{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    {
      packages.omnix-ci = pkgs.writeShellApplication {
        name = "omnix-ci";

        meta.description = ''
          Build all flake outputs with omnix
        '';

        runtimeInputs = [ pkgs.omnix ];

        text = ''
          om ci
        '';
      };

      # TODO: Remove this when https://github.com/NixOS/nixpkgs/pull/472294 is merged
      overlayAttrs = {
        omnix =
          if lib.versionAtLeast pkgs.omnix.version "1.3.2" then
            pkgs.omnix
          else
            pkgs.omnix.overrideAttrs (
              finalAttrs: _prevAttrs: {
                version = "1.3.2";

                src = pkgs.fetchFromGitHub {
                  owner = "juspay";
                  repo = "omnix";
                  tag = "v${finalAttrs.version}";
                  hash = "sha256-D9rAVsSFooVWpSX//gTcRcmgiAjwZYNRMDIctMmwnho=";
                };

                cargoHash = "sha256-3zWbhuZzqkxgM0Js3luR6+Yr5/UGn1EoL6OqxPt94JM=";

                cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
                  inherit (finalAttrs) pname src version;
                  hash = finalAttrs.cargoHash;
                };
              }
            );
      };
    };
}
