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
      packages.sync-flake-lock = pkgs.writeShellApplication {
        name = "sync-flake-lock";

        runtimeInputs = builtins.attrValues {
          inherit (pkgs) jq;
        };

        text = builtins.readFile ./sync-flake-lock.sh;
      };
    };

  unify.nixos = moduleWithSystem (
    { config }:
    {
      nixpkgs.overlays = [
        (_: _: {
          inherit (config.packages) sync-flake-lock;
        })
      ];
    }
  );

  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.sync-flake-lock ];
    };
}
