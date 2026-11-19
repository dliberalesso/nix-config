{
  inputs,
  ...
}:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    {
      config,
      ...
    }:
    {
      make-shells.default = {
        inputsFrom = [
          config.treefmt.build.devShell
        ];
      };

      treefmt = {
        inherit (config.flake-root) projectRootFile;

        # Pre-commit already does this
        flakeCheck = false;

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
          # treefmt-nix 0ba5d67+ defaults indent_size/simplify off; keep shfmt flags explicit
          shfmt = {
            enable = true;
            indent_size = 2;
            simplify = true;
          };

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
