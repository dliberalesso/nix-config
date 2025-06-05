{
  hm,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.uutils-coreutils-noprefix
  ];
}
// hm {
  home.packages = [
    pkgs.uutils-coreutils-noprefix
  ];
}
