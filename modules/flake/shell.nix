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
      pkgs,
      ...
    }:
    {
      make-shells.default = {
        packages = builtins.attrValues {
          inherit (pkgs)
            git
            just
            nh
            nix
            npins
            ;
        };
      };
    };
}
