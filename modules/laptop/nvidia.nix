{
  config,
  pkgs,
  ...
}:
{
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.nvidia-vaapi-driver ];
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;

    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    prime = {
      sync.enable = false;

      offload.enable = false;

      # Make sure to use the correct Bus ID values for your system!
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
