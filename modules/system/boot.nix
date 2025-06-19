{
  unify.nixos = {
    boot.tmp.cleanOnBoot = true;
  };

  unify.modules.laptop.nixos = {
    boot.loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;

        windows = {
          "11-pro" = {
            title = "Windows 11 Pro";
            efiDeviceHandle = "HD1b";
            sortKey = "z_windows";
          };
        };
      };
    };
  };
}
