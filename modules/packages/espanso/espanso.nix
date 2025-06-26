{
  unify.modules.work.nixos =
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
      environment.systemPackages = [ espanso ];

      security.wrappers."espanso-wayland" = {
        source = lib.getExe espanso;
        capabilities = "cap_dac_override+p";
        owner = "root";
        group = "root";
      };
    };
}
