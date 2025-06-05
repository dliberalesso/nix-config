{
  inputs,
  lib,
  ...
}:
lib.optionalAttrs (inputs.flake-root ? flakeModule) {
  imports = [
    inputs.flake-root.flakeModule
  ];
}
// {
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom =
          lib.optionals (config ? flake-root) [
            config.flake-root.devShell
          ]
          ++ lib.optionals (config ? pre-commit) [
            config.pre-commit.devShell
          ];

        packages = with pkgs; [
          git
          just
          nh
        ];
      };
    };
}
