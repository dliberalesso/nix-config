{
  pkgs,
  ...
}:
{
  services.libinput.enable = true;

  # Logitech UDEV rules
  hardware.logitech.wireless.enable = true;

  environment.systemPackages = with pkgs; [
    libratbag
  ];

  services.ratbagd = {
    enable = true;
  };
}
