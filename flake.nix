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

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    git-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
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

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
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

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        nuschtosSearch.follows = "nuschtosSearch";
      };
    };

    nuschtosSearch = {
      url = "github:NuschtOS/search";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    systems.url = "github:nix-systems/default";

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
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

        flake =
          let
            specialArgs = { inherit inputs; };
          in
          {
            nixosConfigurations = {
              nixWSL = withSystem "x86_64-linux" (
                { pkgs
                , system
                , ...
                }:
                nixpkgs.lib.nixosSystem {
                  inherit system pkgs specialArgs;
                  modules = [
                    ./nixos/wsl.nix

                    home-manager.nixosModules.home-manager
                    {
                      home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.dli50 = import ./home/common;
                        extraSpecialArgs = specialArgs;
                      };
                    }
                  ];
                }
              );

              nixavell = withSystem "x86_64-linux" (
                { pkgs
                , system
                , ...
                }:
                nixpkgs.lib.nixosSystem {
                  inherit system pkgs specialArgs;
                  modules = [
                    ./nixos/nixavell

                    home-manager.nixosModules.home-manager
                    {
                      home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.dli50 = import ./home/nixavell.nix;
                        extraSpecialArgs = specialArgs;
                      };
                    }
                  ];
                }
              );
            };

            homeConfigurations.dli50 = withSystem "x86_64-linux" (
              { pkgs
              , ...
              }:
              home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = specialArgs;
                modules = [ ./home/common ];
              }
            );
          };

        perSystem =
          { config
          , pkgs
          , system
          , ...
          }: {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;

              config.allowUnfree = true;
            };

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
