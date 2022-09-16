{
  description = "My NixOS & Home-Manager config";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
      url = "github:nix-community/home-manager";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { home-manager, nixpkgs, ... }@inputs:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in

    {
      nixosConfigurations = {
        nixosWSL = nixpkgs.lib.nixosSystem {
          inherit system;
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

      devShells.${system}.default = import ./shell.nix { inherit pkgs; };
    };
}
