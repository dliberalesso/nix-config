{
  config,
  ...
}:
let
  inherit (config.unify.modules) podman wsl;

  hostName = "nixwsl";
in
{
  unify.hosts.nixos.${hostName} =
    {
      config,
      ...
    }:
    {
      modules = [
        podman
        wsl
      ];

      nixos.nixpkgs.hostPlatform.system = "x86_64-linux";

      users.${config.user.username} = { };
    };
}
