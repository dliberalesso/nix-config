{
  moduleWithSystem,
  ...
}:
{
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

  unify.nixos = moduleWithSystem (
    { config }:
    {
      nixpkgs.overlays = [
        (_: _: {
          inherit (config.packages) lazymoji;
        })
      ];
    }
  );
}
