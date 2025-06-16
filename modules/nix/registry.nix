{
  inputs,
  ...
}:
{
  unify.nixos =
    {
      config,
      lib,
      ...
    }:
    {
      nix = {
        # Make nix3 and legacy nix commands consistent:
        # - Add the inputs to the system's legacy channels
        nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

        # - Add each flake input as a registry
        registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
      };
    };
}
