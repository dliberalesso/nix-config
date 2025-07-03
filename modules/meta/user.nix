{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;

  email = "dliberalesso@gmail.com";
  name = "Douglas Liberalesso";
  username = "dli50";
in
{
  options.user = mkOption {
    type = types.attrsOf types.str;

    default = { inherit email name username; };
  };

  config.unify.options.user = mkOption {
    type = types.attrsOf types.str;

    internal = true;

    default = config.user;
  };
}
