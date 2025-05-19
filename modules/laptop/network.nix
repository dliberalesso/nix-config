{
  lib,
  ...
}:
{
  networking = {
    hostName = "nixavell";

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

    networkmanager.enable = true;

    useDHCP = lib.mkDefault true;
  };
}
