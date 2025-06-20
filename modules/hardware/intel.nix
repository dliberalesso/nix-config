{
  unify.modules.laptop.nixos = {
    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;

      cpu.intel.updateMicrocode = true;
    };

    # enableAllFirmware depends on this
    nixpkgs.config.allowUnfree = true;
  };
}
