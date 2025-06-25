{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages = { inherit (pkgs) nix-init; };
    };
}
