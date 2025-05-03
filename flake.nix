{
  description = "My NixOS & Home-Manager config";

  nixConfig = {
    extra-substituters = [
      "https://cachix.cachix.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://dliberalesso.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "dliberalesso.cachix.org-1:7qs1S5Qd766dYFU86nVux/wRMZ8UEUbhn3Qxp/TwiOc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-root.url = "github:srid/flake-root";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        ags.follows = "ags";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      flake-parts,
      nixpkgs,
      self,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        inputs,
        withSystem,
        ...
      }:
      {
        imports = with inputs; [
          flake-root.flakeModule
          git-hooks.flakeModule
          treefmt-nix.flakeModule

          ./packages
        ];

        systems = [ "x86_64-linux" ];

        flake.nixosConfigurations =
          let
            generateConfig =
              {
                modules,
              }:
              withSystem "x86_64-linux" (
                {
                  pkgs,
                  system,
                  ...
                }:
                nixpkgs.lib.nixosSystem {
                  inherit system pkgs;

                  modules = [ ./modules/core ] ++ modules;

                  specialArgs = { inherit inputs; };
                }
              );
          in
          {
            nixavell = generateConfig {
              modules = [
                ./modules/hyprde
                ./modules/laptop
                ./modules/programs
              ];
            };

            nixWSL = generateConfig {
              modules = [ ./modules/wsl.nix ];
            };
          };

        perSystem =
          {
            config,
            pkgs,
            system,
            ...
          }:
          {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;

              overlays = [
                inputs.hyprpanel.overlay
                self.overlays.default
              ];

              config.allowUnfree = true;
            };

            devShells.default = pkgs.mkShell {
              nativeBuildInputs = [ pkgs.just ];

              shellHook = ''
                ${config.pre-commit.installationScript}
              '';
            };

            pre-commit = {
              check.enable = true;

              settings.hooks = {
                treefmt.enable = true;
                treefmt.package = config.treefmt.build.wrapper;
              };
            };

            treefmt = {
              inherit (config.flake-root) projectRootFile;

              programs = {
                deadnix.enable = true;
                prettier.enable = true;
                nixfmt.enable = true;
                shfmt.enable = true;
                stylua.enable = true;
                statix.enable = true;
                taplo.enable = true;
              };
            };
          };
      }
    );
}
