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
      # WARN: This should be run by the user when needed
      (writeShellScriptBin "setup-pcsc-chrome" ''
        NSSDB="''${HOME}/.pki/nssdb"
        mkdir -p ''${NSSDB}

        ${nssTools}/bin/modutil -force -dbdir sql:$NSSDB -add eToken -libfile ${pcsc-safenet}/lib/libeToken.so
      '')
    ];

    services.pcscd = {
      enable = true;
      plugins = [ pkgs.pcsc-safenet ];
    };
  };
}
