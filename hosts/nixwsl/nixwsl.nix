{
  config,
  ...
}:
let
  unifyModules = config.unify.modules;

  hostName = "nixwsl";
in
{
  unify.hosts.nixos.${hostName} =
    {
      config,
      ...
    }:
    let
      inherit (config.user) username;
    in
    {
      modules = with unifyModules; [
        podman
        wsl
      ];

      nixos.nixpkgs.hostPlatform.system = "x86_64-linux";

      users.${username} = { inherit (config) modules; };
    };
}
