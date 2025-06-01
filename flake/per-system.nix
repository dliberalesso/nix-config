{
  inputs,
  ...
}:
let
  mapListToModule = moduleName: list: map (i: i.${moduleName}) list;
  mapListToFlakeModule = mapListToModule "flakeModule";
  mapListToDevShell = mapListToModule "devShell";
in
{
  imports =
    with inputs;
    mapListToFlakeModule [
      flake-root
      git-hooks
      treefmt-nix
    ];

  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom =
          with config;
          mapListToDevShell [
            flake-root
            pre-commit
          ];

        packages = with pkgs; [
          git
          just
          nh
        ];
      };

      pre-commit = {
        check.enable = true;

        settings.hooks.treefmt.enable = true;
      };

      treefmt = {
        inherit (config.flake-root) projectRootFile;

        programs = {
          deadnix.enable = true;
          prettier.enable = true;
          nixfmt.enable = true;
          shfmt.enable = true;
          stylua.enable = true;
          statix.enable = true;
          taplo.enable = true;
        };
      };
    };
}
