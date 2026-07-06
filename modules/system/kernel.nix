{
  unify.modules.laptop.nixos =
    {
      config,
      pkgs,
      ...
    }:
    {
      boot = {
        # TODO: Re-evaluate zen kernel with newer NVIDIA open driver versions
        kernelPackages = pkgs.linuxPackages;

        kernelModules = [
          "kvm-intel"
          "v4l2loopback"
        ];

        extraModulePackages = [
          config.boot.kernelPackages.v4l2loopback
        ];

        kernel.sysctl = {
          "vm.max_map_count" = 2147483642;
        };

        initrd.availableKernelModules = [
          "xhci_pci"
          "ahci"
          "nvme"
          "usb_storage"
          "usbhid"
          "sd_mod"
          "rtsx_usb_sdmmc"
        ];
      };
    };
}
