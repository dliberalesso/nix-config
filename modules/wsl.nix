{
  config,
  inputs,
  lib,
  pkgs,
  user,
  ...
}:
lib.optionalAttrs (inputs.nixos-wsl ? nixosModules) {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  environment.systemPackages = [ pkgs.wslu ];

  hardware.graphics.enable = lib.mkForce false;

  wsl = {
    enable = true;
    defaultUser = user.username;
    startMenuLaunchers = false;
    wslConf.automount.root = "/mnt";
    wslConf.network.hostname = config.networking.hostName;
  };
}
