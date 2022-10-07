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

    flake-compat.url = "github:edolstra/flake-compat";
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

  outputs = { home-manager, nixpkgs, ... }@inputs:

    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues {
          default = import ./overlays { inherit inputs; };
        };
        config.allowUnfree = true;
      };
    in

    {
      formatter.${system} = pkgs.nixpkgs-fmt;

      nixosConfigurations = {
        nixosWSL = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit inputs; };
          modules = [ ./nixos ];
        };
      };

      homeConfigurations = {
        dli = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home ];
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.git
          # Is this the same home-manager listed in the 'inputs'?
          pkgs.home-manager
          pkgs.nix
          pkgs.nixpkgs-fmt
          pkgs.rnix-lsp
        ];
      };
    };
}
