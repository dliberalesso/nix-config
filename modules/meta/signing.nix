{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;

  signingKeys = lib.filter (key: key != null) (
    lib.map (host: host.signingKey) (lib.attrValues config.unify.hosts.nixos)
  );
in
{
  config.unify.options.signingKey = mkOption {
    type = types.nullOr types.str;

    default = null;

    description = "Public SSH key used to sign Git and Jujutsu commits on this host.";
  };

  config.unify.options.allowedSigners = mkOption {
    type = types.lines;

    internal = true;

    default = lib.concatMapStrings (
      key: "${config.user.email} namespaces=\"git\" ${key}\n"
    ) signingKeys;

    description = "Trusted SSH signing keys, one allowed-signers line per host.";
  };
}
