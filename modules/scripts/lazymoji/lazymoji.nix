{
  moduleWithSystem,
  ...
}:
{
  unify.nixos = moduleWithSystem (
    perSystem@{ config }:
    _: {
      nixpkgs.overlays = [
        (_: _: {
          inherit (perSystem.config.packages) lazymoji;
        })
      ];
    }
  );

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.lazymoji = pkgs.writeShellApplication {
        name = "lazymoji";

        runtimeInputs = builtins.attrValues {
          inherit (pkgs) git gum;
        };

        text = builtins.readFile ./lazymoji.sh;
      };
    };
}
