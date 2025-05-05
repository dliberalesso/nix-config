{
  pkgs,
  ...
}:
{
  home-manager.users.dli50.home.packages = [
    (import ./hypr-monitor-toggle.nix { inherit pkgs; })
  ];
}
