{
  inputs,
  self,
  ...
}:
{
  unify.nixos =
    {
      config,
      hostConfig,
      lib,
      pkgs,
      ...
    }:
    let
      nixpkgs-overlays = pkgs.writeTextFile {
        name = "overlays";
        destination = "/overlays.nix";
        text = # Nix
          ''
            final: prev:
            with prev.lib;
            let
              # Load the system config and get the `nixpkgs.overlays` option
              inherit ((builtins.getFlake "path:''${builtins.toString ${self.outPath}}").nixosConfigurations.${hostConfig.name}.config.nixpkgs) overlays;
            in
            # Apply all overlays to the input of the current "main" overlay
            foldl' (flip extends) (_: prev) overlays final
          '';
      };
    in
    {
      nix = {
        # Make nix3 and legacy nix commands consistent:
        # - Add the inputs to the system's legacy channels
        nixPath = [
          "nixpkgs-overlays=${nixpkgs-overlays}"
        ] ++ (lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry);

        # - Add each flake input as a registry
        registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
      };
    };
}
