{
  inputs,
  lib,
  ...
}:
let
  hasTreefmt = inputs.treefmt-nix ? flakeModule;
in
{
  imports = lib.optionals hasTreefmt [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = lib.mkIf hasTreefmt (
    {
      config,
      ...
    }:
    let
      hasFlakeRoot = config ? flake-root;
    in
    {
      treefmt = {
        projectRootFile = lib.mkIf hasFlakeRoot config.flake-root.projectRootFile;

        flakeCheck = !(config ? pre-commit);

        settings.global.excludes = [
          "*.age" # Age encrypted files
        ];

        programs = {
          actionlint.enable = true;

          deadnix.enable = true;
          nixfmt.enable = true;
          statix.enable = true;

          prettier = {
            enable = true;
            settings.editorconfig = true;
          };

          shellcheck.enable = true;
          shfmt.enable = true;

          stylua = {
            enable = true;
            settings = {
              indent_type = "Spaces";
              indent_width = 2;
              call_parentheses = "Always";
              collapse_simple_statement = "Always";
            };
          };

          taplo.enable = true;
        };
      };
    }
  );
}
