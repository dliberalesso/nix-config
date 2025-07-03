{
  inputs,
  ...
}:
let
  nixpkgs.overlays = [
    inputs.nix.overlays.default
  ];
in
{
  perSystem = { inherit nixpkgs; };

  unify.nixos = { inherit nixpkgs; };
}
