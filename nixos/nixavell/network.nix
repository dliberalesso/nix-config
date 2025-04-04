{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nixos.network;
in
{
  options = {
    hostName = lib.mkOption {
      type = lib.types.string;
    };

    nixos.network = {
      enable = lib.mkEnableOption "Enable network config";
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      inherit (config) hostName;

      useDHCP = lib.mkDefault true;

      networkmanager.enable = true;

      timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

      firewall = {
        enable = true;
        allowedTCPPorts = [
          22
          80
          443
          59010
          59011
          8080
        ];
        allowedUDPPorts = [
          59010
          59011
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
  };
}
