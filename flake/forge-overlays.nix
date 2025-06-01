{
  inputs,
  config,
  lib,
  self,
  ...
}:
let
  inherit (config.forge) overlays;

  t = lib.types;
in
{
  options.forge = {
    overlays = lib.mkOption rec {
      type = t.listOf (t.uniq (t.functionTo (t.functionTo (t.lazyAttrsOf t.unspecified))));

      default = [ self.overlays.default ];

      apply = config: config ++ default;

      example = lib.literalExample ''
        [
          (final: prev: {})
        ]
      '';

      description = ''
        A list of [overlays](https://nixos.org/manual/nixpkgs/stable/#chap-overlays) to be used when importing nixpkgs.

        Note that the overlays themselves are not mergeable. While overlays
        can be composed, the order of composition is significant, but the
        module system does not guarantee sufficiently deterministic
        definition ordering, across versions and when changing `imports`.
      '';
    };
  };

  config = {
    # TODO: Move to their modules
    forge.overlays = [
      inputs.hyprpanel.overlay
      inputs.neovim-nightly-overlay.overlays.default
    ];

    perSystem =
      {
        system,
        ...
      }:
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit overlays system;

          config.allowUnfree = true;
        };
      };
  };
}
