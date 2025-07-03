{
  inputs,
  lib,
  ...
}:
lib.optionalAttrs (inputs.flake-root ? flakeModule) {
  imports = [
    inputs.flake-root.flakeModule
  ];

  perSystem =
    {
      config,
      ...
    }:
    {
      make-shells.default = {
        inputsFrom = [
          config.flake-root.devShell
        ];
      };
    };
}
