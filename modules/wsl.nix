{
  config,
  inputs,
  lib,
  pkgs,
  user,
  ...
}:
let
  inherit (config.networking) hostName;

  nixos-wsl = inputs.nixos-wsl ? nixosModules;

  enabled = nixos-wsl && config.wsl.enable;
in
{
  imports = lib.optionals nixos-wsl [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  config = lib.mkIf enabled {
    environment.systemPackages = [ pkgs.wslu ];

    hardware.graphics.enable = lib.mkForce false;

    wsl = {
      defaultUser = user.username;
      startMenuLaunchers = false;
      wslConf.automount.root = "/mnt";
      wslConf.network.hostname = hostName;
    };
  };
}
