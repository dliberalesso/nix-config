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
      pcsc-safenet
      nssTools

      # FIXME: This should enable the `eToken` on `chrome`
      (writeShellScriptBin "setup-pcsc-chrome" ''
        NSSDB="''${HOME}/.pki/nssdb"
        mkdir -p ''${NSSDB}

        ${nssTools}/bin/modutil -force -dbdir sql:$NSSDB -add eToken -libfile ${pcsc-safenet}/lib/libeToken.so.10
      '')
    ];

    services.pcscd = {
      enable = true;
      plugins = [ pkgs.pcsc-safenet ];
    };

    programs.firefox = {
      enable = true;

      policies.SecurityDevices.Add = {
        eToken = "${pkgs.pcsc-safenet}/lib/libeToken.so.10";
      };
    };
  };
}
