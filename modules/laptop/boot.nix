{
  boot.loader = {
    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;
    };
  };

  # boot.plymouth.enable = true;
}
