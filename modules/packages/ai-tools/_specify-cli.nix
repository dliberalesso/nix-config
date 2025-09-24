{
  fetchFromGitHub,
  lib,
  python3Packages,
}:
let
  version = "0.0.53";
in
python3Packages.buildPythonApplication {
  pname = "specify-cli";
  inherit version;

  pyproject = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "spec-kit";
    rev = "v${version}";
    sha256 = "sha256-jlaPE8HDAlmD+InMTLlAZZR0n5Dvfb026NapGDzXLRE=";
  };

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
}
