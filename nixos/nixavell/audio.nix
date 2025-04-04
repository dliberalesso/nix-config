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
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
