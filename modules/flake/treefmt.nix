{
  inputs,
  lib,
  ...
}:
lib.optionalAttrs (inputs.treefmt-nix ? flakeModule) {
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    {
      config,
      lib,
      ...
    }:
    {
      make-shells.default = {
        inputsFrom = [
          config.treefmt.build.devShell
        ];
      };

      treefmt =
        lib.optionalAttrs (config ? flake-root) {
          inherit (config.flake-root) projectRootFile;
        }
        // {
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
    };
}
