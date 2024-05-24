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

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    flake-parts.url = "github:hercules-ci/flake-parts";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";
    pre-commit-hooks.inputs.flake-compat.follows = "flake-compat";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.flake-compat.follows = "flake-compat";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    { self
    , flake-parts
    , home-manager
    , nixpkgs
    , ...
    } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.pre-commit-hooks.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = nixpkgs.lib.systems.flakeExposed;

      flake = {
        nixosConfigurations = {
          nixosWSL = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            pkgs = self.legacyPackages.x86_64-linux;
            specialArgs = { inherit inputs; };
            modules = [ ./nixos ];
          };
        };

        homeConfigurations = {
          dli = home-manager.lib.homeManagerConfiguration {
            pkgs = self.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [ ./home ];
          };
        };
      };

      perSystem =
        { config
        , pkgs
        , system
        , ...
        }: {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              prettier.enable = true;
              nixpkgs-fmt.enable = true;
              shfmt.enable = true;
              stylua.enable = true;
            };
          };

          pre-commit.check.enable = true;
          pre-commit.settings.hooks = {
            treefmt.enable = true;
            treefmt.package = config.treefmt.build.wrapper;
          };

          legacyPackages = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.allowAliases = true;
          };

          devShells.default = pkgs.mkShell {
            shellHook = ''
              ${config.pre-commit.installationScript}
            '';

            nativeBuildInputs = with pkgs; [
              # Formatters
              nixpkgs-fmt
              stylua

              # Language servers
              lua-language-server
              nixd

              # Tools
              just
            ];
          };
        };
    };
}
