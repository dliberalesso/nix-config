{
  inputs,
  ...
}:
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
      imports = [
        inputs.nixos-facter-modules.nixosModules.facter
      ];

      facter.reportPath = ../../hosts/${hostName}/facter.json;
    };
}
