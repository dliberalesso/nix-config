{
  config,
  ...
}:
let
  hostName = "nixwsl";
in
{
  unify.hosts.nixos.${hostName} = {
    modules = builtins.attrValues {
      inherit (config.unify.modules) wsl;
    };
  };
}
