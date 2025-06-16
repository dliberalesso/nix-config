{
  config,
  ...
}:
let
  hostName = "nixwsl";

  args = import ../_args.nix hostName;
in
{
  imports = [ args ];

  unify.hosts.nixos.${hostName} = {
    modules = builtins.attrValues {
      inherit (config.unify.modules) wsl;
    };
  };
}
