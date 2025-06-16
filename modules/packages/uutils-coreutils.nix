{
  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.uutils-coreutils-noprefix
      ];
    };

  unify.nixos =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        pkgs.uutils-coreutils-noprefix
      ];
    };
}
