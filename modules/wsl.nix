{
  inputs,
  pkgs,
  ...
}:
let
  hostName = "nixWSL";
in
{
  imports = [ inputs.nixos-wsl.nixosModules.wsl ];

  networking = { inherit hostName; };

  # Setup WSL
  wsl = {
    enable = true;
    defaultUser = "dli50";
    startMenuLaunchers = false;
    wslConf.automount.root = "/mnt";
    wslConf.network.hostname = hostName;
  };

  # Packages to install
  environment.systemPackages = [ pkgs.wslu ];
}
