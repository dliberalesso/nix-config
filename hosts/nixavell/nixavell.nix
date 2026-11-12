{
  config,
  ...
}:
let
  unifyModules = config.unify.modules;

  hostName = "nixavell";
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
        facter
        gui
        # irpf
        laptop
        podman
        niride
        work
      ];

      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKyq3xPJDWbCq9ba4CR7fjhs0fkwWT2hRzA2IOz/Dzr dli50@nixavell";

      nixos = {
        imports = [ ./_filesystem.nix ];

        nixpkgs.hostPlatform.system = "x86_64-linux";

        # Don't forget to set a password with ‘passwd’.
        users.users.${username} = {
          extraGroups = [
            "audio"
            "input"
            "networkmanager"
            "video"
          ];
        };
      };

      users.${username} = { inherit (config) modules; };
    };
}
