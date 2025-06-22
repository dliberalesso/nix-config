{
  # HACK: Added this pkg to the flake outputs to avoid rebuilds in CI
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages = { inherit (pkgs) yazi; };
    };

  unify.home.programs = {
    yazi.enable = true;
  };
}
