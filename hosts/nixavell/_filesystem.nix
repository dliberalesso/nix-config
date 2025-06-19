{
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/f327437e-b731-4543-aa04-62d1070d9109";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6441-4E64";
      fsType = "vfat";

      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/96082f77-471f-459f-8438-b4d2d8fcc96e"; } ];
}
