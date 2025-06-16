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

        # TODO: Move to their modules
        overlays = [
          inputs.hyprpanel.overlay
          inputs.neovim-nightly-overlay.overlays.default
        ];
      };
    };
}
