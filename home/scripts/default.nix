{
  pkgs,
  ...
}:
{
  home.packages = [
    (import ./rofi-launcher.nix { inherit pkgs; })
  ];
}
