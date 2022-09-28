{
  description = "My NixOS & Home-Manager config";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
<<<<<<< HEAD

    flake-utils.url = github:numtide/flake-utils;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    vscode-server = {
      url = github:msteen/nixos-vscode-server;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = github:nix-community/NixOS-WSL;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
=======

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    flake-utils.url = github:numtide/flake-utils;

    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.utils.follows = "flake-utils";

    neovim-upstream.url = github:neovim/neovim?dir=contrib;
    neovim-upstream.inputs.nixpkgs.follows = "nixpkgs";
    neovim-upstream.inputs.flake-utils.follows = "flake-utils";

    nixos-wsl.url = github:nix-community/NixOS-WSL;
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.flake-compat.follows = "flake-compat";
    nixos-wsl.inputs.flake-utils.follows = "flake-utils";

    vscode-server.url = github:msteen/nixos-vscode-server;
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";
>>>>>>> main
  };

  outputs = { home-manager, neovim-upstream, nixpkgs, ... }@inputs:

    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;

        overlays = [
          # Why can't I just use 'neovim-upstream.overlay'?
          (final: prev: {
            neovim-unwrapped = neovim-upstream.packages.${system}.neovim;
          })
        ];

        config.allowUnfree = true;
      };
    in

    {
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
