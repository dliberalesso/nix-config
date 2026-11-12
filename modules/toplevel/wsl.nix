{
  inputs,
  ...
}:
{
  unify.modules.wsl.nixos =
    {
      hostConfig,
      lib,
      ...
    }:
    {
      imports = [
        inputs.nixos-wsl.nixosModules.wsl
      ];

      hardware.graphics.enable = lib.mkForce false;

      wsl = {
        enable = true;
        defaultUser = hostConfig.user.username;
        startMenuLaunchers = false;

        ssh-agent.enable = true;

        wslConf = {
          automount.root = "/mnt";
          interop.appendWindowsPath = false;
          network.hostname = hostConfig.name;
        };
      };
    };
}
