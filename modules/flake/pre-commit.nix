{
  inputs,
  ...
}:
{
  imports = [
    inputs.git-hooks.flakeModule
  ];

  perSystem =
    {
      config,
      ...
    }:
    {
      pre-commit.settings = {
        excludes = [
          "^.age"
          "^.gitignore"
          "^.gitmodules"
          "^.lock"
          "^.patch"
        ];

        hooks = {
          treefmt.enable = config ? treefmt;

          editorconfig-checker.enable = true;

          # General use pre-commit hooks
          trim-trailing-whitespace.enable = true;
          mixed-line-endings.enable = true;
          end-of-file-fixer.enable = true;
          check-executables-have-shebangs.enable = true;
          check-added-large-files.enable = true;

          gitleaks.enable = true;
        };
      };

      make-shells.default = {
        inputsFrom = [
          config.pre-commit.devShell
        ];
      };
    };
}
