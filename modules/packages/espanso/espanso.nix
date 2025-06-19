{
  unify.modules.gui.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      espanso = pkgs.callPackage ./_espanso-capdacoverride.nix {
        capDacOverrideWrapperDir = "${config.security.wrapperDir}";
      };
    in
    {
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
