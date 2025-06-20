{
  config,
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

      users.${config.user.username} = { };
    };
}
