{
  description = "My NixOS & Home-Manager config";

  nixConfig = {
    extra-substituters = [
      "https://dliberalesso.cachix.org"
      "https://catppuccin.cachix.org"
      "https://hyprland.cachix.org"
      "https://cachix.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
    ];

    extra-trusted-public-keys = [
      "dliberalesso.cachix.org-1:7qs1S5Qd766dYFU86nVux/wRMZ8UEUbhn3Qxp/TwiOc="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
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

    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
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

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
        hercules-ci-effects.follows = "hercules-ci-effects";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
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

    plugins-wezterm-types = {
      url = "github:gonstoll/wezterm-types";
      flake = false;
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
                inputs.neovim-nightly-overlay.overlays.default
                self.overlays.default
              ];

              config.allowUnfree = true;
            };

            devShells.default = pkgs.mkShell {
              packages = with pkgs; [
                git
                just
                nh
              ];

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
