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
      inherit (pkgs) python3Packages;

      src = pins.specify-cli { inherit pkgs; };
    in
    {
      packages = { inherit (pkgs) specify-cli; };

      overlayAttrs = {
        specify-cli = python3Packages.buildPythonApplication {
          pname = "specify-cli";
          version = lib.strings.removePrefix "v" src.version;

          pyproject = true;

          inherit src;

          nativeBuildInputs = with python3Packages; [
            hatchling
          ];

          dependencies = with python3Packages; [
            httpx-socks
            platformdirs
            readchar
            rich
            truststore
            typer
          ];

          # Disable runtime dependency checks since the available versions in nixpkgs
          # may not match exactly what's specified in pyproject.toml
          pythonImportsCheck = [ ];
          doCheck = false;
          dontCheckRuntimeDeps = true;

          meta = {
            description = "Specify CLI, part of GitHub Spec Kit. A tool to bootstrap your projects for Spec-Driven Development (SDD).";
            homepage = "https://github.com/github/spec-kit";
            changelog = "https://github.com/github/spec-kit/blob/main/CHANGELOG.md";
            license = lib.licenses.mit;
            sourceProvenance = with lib.sourceTypes; [ fromSource ];
            maintainers = [ ];
            platforms = lib.platforms.all;
            mainProgram = "specify";
          };
        };
      };
    };

  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.specify-cli ];
    };
}
