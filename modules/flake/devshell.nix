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
      lib,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = lib.optionals (config ? flake-root) [
          config.flake-root.devShell
        ];

        packages = builtins.attrValues {
          inherit (config.packages) lazymoji;

          inherit (pkgs)
            git
            just
            nh
            nix
            ;
        };

        shellHook = lib.optionalString (config ? pre-commit) config.pre-commit.installationScript;
      };
    };
}
