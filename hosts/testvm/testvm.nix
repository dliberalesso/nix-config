{
  inputs,
  self,
  ...
}:
let
  hostName = "testvm";

  args = import ../_args.nix hostName;
in
{
  imports = [ args ];

  unify.hosts.nixos.${hostName}.nixos =
    {
      hostConfig,
      ...
    }:
    {

      imports = map (p: "${inputs.nixpkgs}/nixos/modules${p}.nix") [
        "/profiles/minimal"
        "/virtualisation/qemu-vm"
      ];

      security.sudo.wheelNeedsPassword = false;

      services.getty = {
        autologinUser = hostConfig.user.username;

        helpLine = ''
          If you are connect via serial console:
          Type Ctrl-a c to switch to the qemu console
          and `quit` to stop the VM.
        '';
      };

      users.users.${hostConfig.user.username} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        initialHashedPassword = "";
      };

      virtualisation = {
        cores = 2;
        graphics = false;
        memorySize = 2048;
      };
    };

  perSystem.apps.${hostName} = {
    meta.description = "run Nixos in a VM";

    program = "${self.nixosConfigurations.${hostName}.config.system.build.vm}/bin/run-${hostName}-vm";
  };
}
