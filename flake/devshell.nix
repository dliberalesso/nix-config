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
      inputs',
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = lib.optionals (config ? flake-root) [
          config.flake-root.devShell
        ];

        packages = builtins.attrValues {
          inherit (inputs'.nix.packages) nix;

          inherit (pkgs)
            git
            just
            nh
            ;
        };

        shellHook = lib.optionalString (config ? pre-commit) config.pre-commit.installationScript;
      };
    };
}
