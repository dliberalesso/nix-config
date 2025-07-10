{
  inputs,
  self,
  ...
}:
let
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      self.overlays.default
    ];
  };
in
{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  perSystem =
    {
      system,
      ...
    }:
    {
      imports = [
        "${inputs.nixpkgs}/nixos/modules/misc/nixpkgs.nix"
        { inherit nixpkgs; }
      ];

      nixpkgs.hostPlatform = { inherit system; };
    };

  unify.nixos = { inherit nixpkgs; };
}
