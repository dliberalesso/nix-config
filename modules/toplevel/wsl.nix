{
  inputs,
  ...
}:
{
  unify.modules.wsl.nixos =
    {
      hostConfig,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.nixos-wsl.nixosModules.wsl
      ];

      environment.systemPackages = [ pkgs.wslu ];

      hardware.graphics.enable = lib.mkForce false;

      wsl = {
        enable = true;
        defaultUser = hostConfig.user.username;
        startMenuLaunchers = false;

        wslConf = {
          automount.root = "/mnt";
          interop.appendWindowsPath = false;
          network.hostname = hostConfig.name;
        };
      };
    };
}
