{
  pkgs,
  ...
}:
{
  # Logitech UDEV rules
  hardware.logitech.wireless.enable = true;

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "br";
  #   variant = "nodeadkeys";
  # };

  # services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    keyd
    (libratbag.overrideAttrs (_: {
      postPatch = ''
        substituteInPlace data/devices/logitech-g502-x-wireless.device \
          --replace "DeviceMatch=usb:046d:c098" "DeviceMatch=usb:046d:c098;usb:046d:c547"
      '';
    }))
  ];

  services.ratbagd.enable = true;

  # Remap keys & mouse buttons
  # TODO: remap caps -> esc on laptops kbd too
  services.keyd = {
    enable = true;
    keyboards = {
      internalkbd = {
        ids = [ "0001:0001:70533846" ];
        settings = {
          main = {
            capslock = "esc";
          };
        };
      };
      externalkbd = {
        ids = [
          "258a:0090:fcfe2b1f"
          "258a:0090:ab99cdb6"
        ];
        settings = {
          main = {
            capslock = "esc";
            esc = "`";
          };
        };
      };
    };
  };

  # environment.variables = {
  #   GTK_IM_MODULE = "cedilla";
  #   QT_IM_MODULE = "cedilla";
  # };

  # Optional, but makes sure that when you type the make palm rejection work with keyd
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
