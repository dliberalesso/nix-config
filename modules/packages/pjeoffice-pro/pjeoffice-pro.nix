{
  perSystem =
    {
      pkgs,
      ...
    }:
    let
      pjeoffice-pro = pkgs.callPackage ./_pjeoffice-pro.nix { };
    in
    {
      overlayAttrs = { inherit pjeoffice-pro; };

      packages = { inherit pjeoffice-pro; };
    };

  unify.modules.work.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [ pjeoffice-pro ];
    };
}
