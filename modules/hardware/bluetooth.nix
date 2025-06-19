{
  unify.modules.laptop.nixos = {
    # https://wiki.nixos.org/wiki/Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };
}
