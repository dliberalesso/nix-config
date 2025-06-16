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
          # inherit (config.packages) lazymoji;

          inherit (inputs'.nix.packages) nix;

          inherit (pkgs)
            git
            jujutsu
            just
            lazymoji
            nh
            ;
        };

        shellHook = lib.optionalString (config ? pre-commit) config.pre-commit.installationScript;
      };
    };
}
