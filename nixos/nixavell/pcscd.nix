{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixos.pcscd;
in
{
  options.nixos.pcscd = {
    enable = lib.mkEnableOption "Enable eToken options";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pcsc-tools
    ];

    services.pcscd = {
      enable = true;
      plugins = [ pkgs.pcsc-safenet ];
    };

    programs.firefox = {
      enable = true;

      policies.SecurityDevices.Add = {
        "PKCS#11 JFRS" = "${pkgs.pcsc-safenet}/lib/libeToken.so";
      };
    };
  };
}
