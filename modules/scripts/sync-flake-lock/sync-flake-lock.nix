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

  unify.home = moduleWithSystem (
    { config }:
    {
      home.packages = [ config.packages.sync-flake-lock ];
    }
  );
}
