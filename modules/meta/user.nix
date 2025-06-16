{
  lib,
  ...
}:
let
  user = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;

    default = {
      email = "dliberalesso@gmail.com";
      name = "Douglas Liberalesso";
      username = "dli50";
    };
  };
in
{
  options = { inherit user; };

  config.unify.options = { inherit user; };
}
