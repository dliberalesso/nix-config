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
    imports = [
      inputs.determinate.nixosModules.default
    ];

    # Disables Determinate's garbage collections because we use NH
    environment.etc."determinate/config.json".text = ''
      {
        "garbageCollector": {
          "strategy": "disabled"
        }
      }
    '';

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
