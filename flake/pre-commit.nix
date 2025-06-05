{
  inputs,
  lib,
  ...
}:
let
  inherit (inputs) git-hooks;
  inherit (lib) optionals;

  hasGitHooks = git-hooks ? flakeModule;
in
{
  imports = optionals hasGitHooks [ git-hooks.flakeModule ];

  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      pre-commit.settings =
        let
          hasTreefmt = config ? treefmt;
          treefmtWrapper = if hasTreefmt then config.treefmt.build.wrapper else pkgs.treefmt;
        in
        {
          excludes = [
            "^.lock"
            "^.patch"
            "package-lock.json"
            "go.mod"
            "go.sum"
            ".gitignore"
            ".gitmodules"
            ".hgignore"
            ".svnignore"
            "^.age"
          ];

          hooks = {
            treefmt.enable = hasTreefmt;
            treefmt.package = treefmtWrapper;

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
