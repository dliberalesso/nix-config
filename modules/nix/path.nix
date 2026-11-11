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

      # Search paths shared by $NIX_PATH (nix.nixPath) and nix.conf (nix.settings.nix-path)
      path-list = [
        "nixpkgs-overlays=${nixpkgs-overlays}"
      ]
      ++ (lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry);
    in
    {
      nix = {
        # - Add each flake input as a registry
        registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

        # nix.nixPath is the only NixOS option that exports $NIX_PATH.
        # A plain definition shadows the upstream mkDefault
        # (nixpkgs.flake.setNixPath), so its entries are carried over here.
        nixPath = [
          "nixpkgs=flake:nixpkgs"
        ]
        ++ (lib.optional config.nix.channel.enable "/nix/var/nix/profiles/per-user/root/channels")
        ++ path-list;

        # Make nix3 and legacy nix commands consistent:
        # - Add the inputs to the system's legacy channels
        settings.nix-path = path-list;
      };
    };
}
