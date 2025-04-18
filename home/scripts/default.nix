{
  pkgs,
  ...
}:
{
  home.packages = [
    (import ./hypr-monitor-toggle.nix { inherit pkgs; })
    (import ./rofi-launcher.nix { inherit pkgs; })
  ];
}
