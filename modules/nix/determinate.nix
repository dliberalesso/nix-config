{
  inputs,
  ...
}:
let
  nixpkgs.overlays = [
    inputs.nix-src.overlays.default
  ];
in
{
  perSystem = { inherit nixpkgs; };

  unify.nixos = {
    inherit nixpkgs;

    nix.settings = {
      eval-cores = 0; # Evaluate across all cores

      extra-experimental-features = [
        "build-time-fetch-tree"
        "parallel-eval"
        "pipe-operators"
      ];

      extra-substituters = [
        "https://install.determinate.systems"
      ];

      extra-trusted-public-keys = [
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      ];

      lazy-trees = true;
    };
  };
}
