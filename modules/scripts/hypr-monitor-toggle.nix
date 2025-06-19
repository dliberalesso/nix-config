{
  unify.modules.hyprde.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ (pkgs.callPackage ./_hypr-monitor-toggle.nix { }) ];
    };
}
