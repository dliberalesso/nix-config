{
  description = "My NixOS & Home-Manager config";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    flake-utils.url = github:numtide/flake-utils;

    dracula-nvim.url = github:Mofiqul/dracula.nvim;
    dracula-nvim.flake = false;

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
  };

  outputs = { home-manager, neovim-upstream, nixpkgs, ... }@inputs:

    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues {
          default = import ./overlays { inherit inputs; };
          neovim-upstream = neovim-upstream.overlay;
        };
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
