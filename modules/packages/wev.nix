{
  unify.modules.hyprde.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.wev ];
    };
}
