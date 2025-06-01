{
  inputs,
  withSystem,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) mkMerge nixosSystem;

  generateConfig = config: {
    ${config.networking.hostName} = withSystem "x86_64-linux" (
      {
        pkgs,
        system,
        ...
      }:
      nixosSystem {
        inherit system pkgs;

        modules = [
          ../modules/core
          ../modules/wsl.nix

          config

          { system.stateVersion = "25.05"; }
        ];

        specialArgs = rec {
          inherit inputs;

          hm = args: {
            home-manager.users.${user.username} = args;
          };

          user = {
            email = "dliberalesso@gmail.com";
            name = "Douglas Liberalesso";
            username = "dli50";
          };
        };
      }
    );
  };
in
{
  flake.nixosConfigurations = mkMerge (
    map generateConfig [
      {
        imports = [
          ../modules/hyprde
          ../modules/laptop
          ../modules/programs
        ];

        networking.hostName = "nixavell";
      }
      {
        networking.hostName = "nixWSL";

        wsl.enable = true;
      }
    ]
  );
}
