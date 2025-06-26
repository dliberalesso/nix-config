{
  unify.modules.laptop.nixos = {
    services.libinput.enable = true;

    # Logitech UDEV rules
    hardware.logitech.wireless.enable = true;
  };
}
