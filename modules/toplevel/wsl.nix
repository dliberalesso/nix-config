{
  inputs,
  lib,
  ...
}:
let
  assertPresent = lib.asserts.assertMsg (
    inputs.nixos-wsl ? nixosModules
  ) "inputs.nixos-wsl doesn't provide nixosModules";
in
lib.optionalAttrs assertPresent {
  unify.modules.wsl.nixos =
    {
      config,
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
        wslConf.automount.root = "/mnt";
        wslConf.network.hostname = config.networking.hostName;
      };
    };
}
