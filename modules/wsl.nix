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

  cfg = config.wsl.enable;
in
{
  imports = [ inputs.nixos-wsl.nixosModules.wsl ];

  wsl = {
    defaultUser = user.username;
    startMenuLaunchers = false;
    wslConf.automount.root = "/mnt";
    wslConf.network.hostname = hostName;
  };

  # Packages to install
  environment.systemPackages = lib.mkIf cfg [ pkgs.wslu ];
}
