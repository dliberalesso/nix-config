{
  config,
  lib,
  ...
}:
let
  cfg = config.nixos.audio;
in
{
  options.nixos.audio = {
    enable = lib.mkEnableOption "Enable audio config";
  };

  config = lib.mkIf cfg.enable {
    # https://wiki.nixos.org/wiki/Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    security.rtkit.enable = true;

    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
