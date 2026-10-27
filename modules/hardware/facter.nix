{
  unify.modules.facter.nixos =
    {
      config,
      ...
    }:
    let
      inherit (config.networking) hostName;
    in
    {
      # nixos-facter-modules is deprecated
      # the modules have been upstreamed to nixpkgs
      hardware.facter = {
        enable = true;

        reportPath = ../../hosts/${hostName}/facter.json;
      };
    };
}
