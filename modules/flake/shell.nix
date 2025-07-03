{
  inputs,
  ...
}:
{
  imports = [
    inputs.make-shell.flakeModules.default
  ];

  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      make-shells.default = {
        packages = builtins.attrValues {
          inherit (config.packages) lazymoji;

          inherit (pkgs)
            git
            just
            nh
            nix
            ;
        };
      };
    };
}
