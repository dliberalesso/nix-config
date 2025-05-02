{
  config,
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    kernelModules = [
      "kvm-intel"
      "nvidia"
      "nvidiafb"
      "nvidia_drm"
      "nvidia_uvm"
      "nvidia_modeset"
      "v4l2loopback"
    ];

    extraModulePackages = [
      config.boot.kernelPackages.nvidia_x11
      config.boot.kernelPackages.v4l2loopback
    ];

    blacklistedKernelModules = [
      "i915"
    ];

    kernelParams = [
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
      "module_blacklist=i915"
    ];

    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "rtsx_usb_sdmmc"
      ];

      kernelModules = [
        "nvidia"
        "nvidiafb"
        "nvidia_drm"
        "nvidia_uvm"
        "nvidia_modeset"
      ];
    };

    loader = {
      systemd-boot.enable = false;

      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
      };

      efi.canTouchEfiVariables = true;
    };

    # plymouth.enable = true;
  };
}
