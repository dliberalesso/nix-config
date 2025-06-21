{
  inputs,
  self,
  withSystem,
  ...
}:
let
  hostName = "testvm";
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
      nixos = {
        imports = map (p: "${inputs.nixpkgs}/nixos/modules${p}.nix") [
          "/profiles/minimal"
          "/virtualisation/qemu-vm"
        ];

        nixpkgs = withSystem "x86_64-linux" (
          {
            system,
            ...
          }:
          {
            hostPlatform = { inherit system; };
          }
        );

        security.sudo.wheelNeedsPassword = false;

        services.getty = {
          autologinUser = username;

          helpLine = ''
            If you are connect via serial console:
            Type Ctrl-a c to switch to the qemu console
            and `quit` to stop the VM.
          '';
        };

        users.users.${username} = {
          initialHashedPassword = "";
        };

        virtualisation = {
          cores = 2;
          graphics = false;
          memorySize = 2048;
        };
      };

      users.${username} = { };
    };

  perSystem.apps.${hostName} = {
    meta.description = "run Nixos in a VM";

    program = "${self.nixosConfigurations.${hostName}.config.system.build.vm}/bin/run-${hostName}-vm";
  };
}
