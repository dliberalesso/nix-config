{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  # Setup WSL
  wsl = {
    enable = true;
    defaultUser = "dli50";
    startMenuLaunchers = false;
    wslConf.automount.root = "/mnt";
    wslConf.network.hostname = "nixWSL";
  };

  # Packages to install
  environment.systemPackages = with pkgs; [
    wslu # Utilities for WSL, i.e. wslview
  ];
}
