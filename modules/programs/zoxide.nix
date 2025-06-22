{
  # HACK: Added this pkg to the flake outputs to avoid rebuilds in CI
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages = { inherit (pkgs) zoxide; };
    };

  unify.home.programs = {
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}
