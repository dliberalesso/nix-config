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

      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHhLqJ4I7F3MPh+yv01+3AIlAhrMCuFm1kMi0DXYJNK jfrs\\dli50@HP-BRJ514R324";

      nixos.nixpkgs.hostPlatform.system = "x86_64-linux";

      users.${username} = { inherit (config) modules; };
    };
}
