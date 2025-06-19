{
  unify.modules.laptop.nixos = {
    hardware = {
      enableAllFirmware = true;
      cpu.intel.updateMicrocode = true;
    };
  };
}
