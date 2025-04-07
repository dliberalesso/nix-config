{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.nixos.network;
in
{
  options = {
    hostName = lib.mkOption {
      type = lib.types.str;
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
          # SSH
          22

          # HTTP
          80
          443
          8080
        ];
        allowedUDPPorts = [
          #DHCP
          68
          546
        ];
      };
    };
  };
}
