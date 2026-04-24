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
        packages = with pkgs; [
          git
          just
          nh
          nix
        ];
      };
    };
}
