{
  unify.modules.work.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        (pkgs.callPackage ./_pjeoffice-pro.nix { })
      ];
    };
}
