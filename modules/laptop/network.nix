{
  lib,
  options,
  ...
}:
{
  networking = {
    hostName = "nixavell";

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
}
