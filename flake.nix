{
  description = "My NixOS & Home-Manager config";

  nixConfig = {
    extra-substituters = [
      "https://cachix.cachix.org"
      "https://nix-community.cachix.org"
      "https://dliberalesso.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "dliberalesso.cachix.org-1:7qs1S5Qd766dYFU86nVux/wRMZ8UEUbhn3Qxp/TwiOc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-root.url = "github:srid/flake-root";

    git-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { flake-parts
    , home-manager
    , nixpkgs
    , ...
    } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem
      , inputs
      , ...
      }: {
        imports = with inputs; [
          flake-root.flakeModule
          git-hooks.flakeModule
          treefmt-nix.flakeModule
        ];

        systems = [ "x86_64-linux" ];

        flake = {
          nixosConfigurations.nixosWSL = withSystem "x86_64-linux" (
            { pkgs
            , system
            , ...
            }:
            nixpkgs.lib.nixosSystem {
              inherit system pkgs;
              specialArgs = { inherit inputs; };
              modules = [ ./nixos ];
            }
          );

          homeConfigurations.dli = withSystem "x86_64-linux" (
            { pkgs
            , ...
            }:
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = { inherit inputs; };
              modules = [ ./home ];
            }
          );
        };

        perSystem =
          { config
          , pkgs
          , ...
          }: {
            devShells.default = pkgs.mkShell {
              nativeBuildInputs = with pkgs; [
                just
              ];

              shellHook = ''
                ${config.pre-commit.installationScript}
              '';
            };

            pre-commit.check.enable = true;
            pre-commit.settings.hooks = {
              treefmt.enable = true;
              treefmt.package = config.treefmt.build.wrapper;
            };

            treefmt = {
              inherit (config.flake-root) projectRootFile;
              programs = {
                prettier.enable = true;
                nixpkgs-fmt.enable = true;
                shfmt.enable = true;
                stylua.enable = true;
              };
            };
          };
      }
    );
}
