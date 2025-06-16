{
  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.cachix ];
    };
}
