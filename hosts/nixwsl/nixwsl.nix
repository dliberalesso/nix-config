{
  config,
  withSystem,
  ...
}:
let
  inherit (config.unify.modules) wsl;

  hostName = "nixwsl";
in
{
  unify.hosts.nixos.${hostName} =
    {
      config,
      ...
    }:
    {
      modules = [ wsl ];

      nixos.nixpkgs = withSystem "x86_64-linux" (
        {
          system,
          ...
        }:
        {
          hostPlatform = { inherit system; };
        }
      );

      users.${config.user.username} = { };
    };
}
