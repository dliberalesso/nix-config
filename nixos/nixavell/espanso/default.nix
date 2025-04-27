{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixos.espanso;

  espanso = pkgs.callPackage ./espanso-capdacoverride.nix {
    capDacOverrideWrapperDir = "${config.security.wrapperDir}";
    espanso = pkgs.espanso-wayland;
  };
in
{
  options.nixos.espanso = {
    enable = lib.mkEnableOption "Enable espanso";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      espanso

      (pkgs.writeShellScriptBin "start-espanso" ''
        ${lib.getExe pkgs.uwsm} app -- ${lib.getExe espanso} daemon
      '')
    ];

    security.wrappers."espanso-wayland" = {
      source = lib.getExe espanso;
      capabilities = "cap_dac_override+p";
      owner = "root";
      group = "root";
    };
  };
}
