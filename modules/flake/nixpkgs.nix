{
  inputs,
  ...
}:
{
  perSystem =
    {
      system,
      ...
    }:
    {
      imports = [
        "${inputs.nixpkgs}/nixos/modules/misc/nixpkgs.nix"
      ];

      nixpkgs = {
        config.allowUnfree = true;

        hostPlatform = { inherit system; };
      };
    };
}
