{
  # HACK: Added this pkg to the flake outputs to avoid rebuilds in CI
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages = { inherit (pkgs) ripgrep-all; };
    };

  unify.home.programs = {
    ripgrep-all.enable = true;
  };
}
