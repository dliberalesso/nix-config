{
  withSystem,
  ...
}:
{
  unify.nixos = withSystem "x86_64-linux" (
    { system, ... }:
    { lib, ... }:
    {
      nixpkgs = {
        config.allowUnfreePredicate = pkg: lib.warn "Allowing unfree package: ${lib.getName pkg}" true;

        hostPlatform = { inherit system; };
      };
    }
  );
}
