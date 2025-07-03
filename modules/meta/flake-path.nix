{
  config,
  lib,
  ...
}:
let
  inherit (config.user) username;
  inherit (lib) mkOption types;
in
{
  options.flakePath = mkOption {
    type = types.str;

    default = "/home/${username}/projects/nix-config";
  };

  config.unify.options.flakePath = mkOption {
    type = types.str;

    internal = true;

    default = config.flakePath;
  };
}
