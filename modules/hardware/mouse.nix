{
  unify.modules.laptop.nixos =
    {
      pkgs,
      ...
    }:
    {
      services.libinput.enable = true;

      # Logitech UDEV rules
      hardware.logitech.wireless.enable = true;

      environment.systemPackages = [ pkgs.libratbag ];

      services.ratbagd.enable = true;
    };
}
