{
  moduleWithSystem,
  ...
}:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.pjeoffice-pro = pkgs.callPackage ./_pjeoffice-pro.nix { };
    };

  unify.modules.work.home = moduleWithSystem (
    { config }:
    {
      home.packages = [
        config.packages.pjeoffice-pro
      ];
    }
  );
}
