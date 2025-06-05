{
  inputs,
  lib,
  ...
}:
lib.optionalAttrs (inputs.git-hooks ? flakeModule) {
  imports = [
    inputs.git-hooks.flakeModule
  ];

  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      pre-commit.settings = {
        excludes = [
          "^.lock"
          "^.patch"
          "package-lock.json"
          "go.mod"
          "go.sum"
          "^.gitignore"
          "^.gitmodules"
          "^.hgignore"
          "^.svnignore"
          "^.age"
        ];

        hooks =
          lib.optionalAttrs (config ? treefmt) {
            treefmt.enable = true;
            treefmt.package = config.treefmt.build.wrapper;
          }
          // {
            commitizen.enable = true;

            editorconfig-checker.enable = true;

            # General use pre-commit hooks
            trim-trailing-whitespace.enable = true;
            mixed-line-endings.enable = true;
            end-of-file-fixer.enable = true;
            check-executables-have-shebangs.enable = true;
            check-added-large-files.enable = true;

            gitleaks = {
              enable = true;
              name = "gitleaks";
              entry = "${pkgs.gitleaks}/bin/gitleaks protect --verbose --redact --staged";
              pass_filenames = false;
            };
          };
      };
    };
}
