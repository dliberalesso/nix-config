{
  inputs,
  lib,
  ...
}:
let
  inherit (inputs) flake-root git-hooks;
  inherit (lib) optionals;

  hasFlakeRoot = flake-root ? flakeModule;
  hasGitHooks = git-hooks ? flakeModule;
in
{
  imports = optionals hasFlakeRoot [ flake-root.flakeModule ];

  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom =
          optionals hasFlakeRoot [ config.flake-root.devShell ]
          ++ optionals hasGitHooks [ config.pre-commit.devShell ];

        packages = with pkgs; [
          git
          just
          nh
        ];
      };
    };
}
