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
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;

    flake-compat.url = github:edolstra/flake-compat;
    flake-compat.flake = false;

    flake-utils.url = github:numtide/flake-utils;

    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.utils.follows = "flake-utils";

    nixos-wsl.url = github:nix-community/NixOS-WSL;
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.flake-compat.follows = "flake-compat";
    nixos-wsl.inputs.flake-utils.follows = "flake-utils";

    vscode-server.url = github:msteen/nixos-vscode-server;
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, flake-utils, home-manager, nixpkgs, ... } @ inputs:
    {
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
    }

    //

    flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues {
          default = import ./overlays { inherit inputs; };
        };
        config.allowUnfree = true;
        config.allowAliases = true;
      };

      formatter = self.legacyPackages.${system}.nixpkgs-fmt;

      devShells.default = with self.legacyPackages.${system}; mkShell {
        buildInputs = [
          act
          git
          home-manager.packages.${system}.default
          nix
          nixpkgs-fmt
          rnix-lsp
        ];
      };
    });
}
