{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixos.nvidia;
in
{
  options.nixos.nvidia = {
    enable = lib.mkEnableOption "Enable nvidia driver";
  };

  config = lib.mkIf cfg.enable {

    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = true;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      # powerManagement.finegrained = true;

      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;

      # prime = {
      #   sync.enable = false;
      #
      #   offload = {
      #     enable = true;
      #     enableOffloadCmd = true;
      #   };
      #
      #   # Make sure to use the correct Bus ID values for your system!
      #   intelBusId = "PCI:0:2:0";
      #   nvidiaBusId = "PCI:1:0:0";
      # };
    };
  };
}
