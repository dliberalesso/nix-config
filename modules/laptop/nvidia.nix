{
  config,
  pkgs,
  ...
}:
{
  # Kernel settings for Nvidia
  boot = {
    kernelModules = [
      "nvidia"
      "nvidiafb"
      "nvidia_drm"
      "nvidia_uvm"
      "nvidia_modeset"
    ];

    extraModulePackages = [
      config.boot.kernelPackages.nvidia_x11
    ];

    blacklistedKernelModules = [ "i915" ];

    kernelParams = [
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
      "module_blacklist=i915"
    ];

    initrd.kernelModules = [
      "nvidia"
      "nvidiafb"
      "nvidia_drm"
      "nvidia_uvm"
      "nvidia_modeset"
    ];
  };

  hardware = {
    # Enable OpenGL
    graphics = {
      enable = true;
      extraPackages = [ pkgs.nvidia-vaapi-driver ];
    };

    nvidia = {
      modesetting.enable = true;

      powerManagement.enable = true;

      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;

      prime = {
        # Running dGPU only
        # Disable sync and offload
        sync.enable = false;
        offload.enable = false;

        # Make sure to use the correct Bus ID values
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
}
