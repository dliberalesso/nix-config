{
  unify.modules.laptop.nixos =
    {
      config,
      pkgs,
      ...
    }:
    {
      # Kernel settings for Nvidia
      boot = {
        blacklistedKernelModules = [ "nouveau" ];

        extraModulePackages = [
          config.boot.kernelPackages.nvidiaPackages.beta
        ];

        initrd.kernelModules = [
          "dm_mod"
        ];

        kernelParams = [
          "nvidia_drm.modeset=1"
          "nvidia_drm.fbdev=1"
        ];
      };

      hardware = {
        # Enable OpenGL
        graphics = {
          enable = true;

          extraPackages = with pkgs; [
            nvidia-vaapi-driver
          ];
        };

        nvidia = {
          package = config.boot.kernelPackages.nvidiaPackages.beta;

          modesetting.enable = true;

          nvidiaSettings = true;

          open = true;

          powerManagement = {
            enable = true;
            finegrained = true;
          };

          prime = {
            sync.enable = false;

            offload = {
              enable = true;
              enableOffloadCmd = true;
            };

            # Make sure to use the correct Bus ID values
            intelBusId = "PCI:0@0:2:0";
            nvidiaBusId = "PCI:1@0:0:0";
          };
        };
      };

      # Load nvidia driver for Xorg and Wayland
      services.xserver.videoDrivers = [
        "modesetting"
        "nvidia"
      ];
    };
}
