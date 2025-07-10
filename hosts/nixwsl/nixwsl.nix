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

      nixos.nixpkgs.hostPlatform.system = "x86_64-linux";

      users.${config.user.username} = { };
    };
}
