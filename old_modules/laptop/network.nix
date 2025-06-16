{
  lib,
  ...
}:
{
  networking = {
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

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    useDHCP = lib.mkDefault true;

    wireless.iwd.enable = true;
  };
}
