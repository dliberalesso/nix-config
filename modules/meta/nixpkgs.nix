{
  withSystem,
  ...
}:
{
  unify.nixos = withSystem "x86_64-linux" (
    {
      pkgs,
      system,
      ...
    }:
    {
      nixpkgs = {
        inherit pkgs;

        hostPlatform = { inherit system; };
      };
    }
  );
}
