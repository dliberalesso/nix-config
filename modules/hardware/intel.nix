{
  unify.modules.laptop.nixos = {
    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;

      cpu.intel.updateMicrocode = true;
    };
  };
}
