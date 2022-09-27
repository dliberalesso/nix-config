{
  description = "My NixOS & Home-Manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    neovim-nightly = {
      url = github:neovim/neovim?dir=contrib;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { home-manager, nixpkgs, neovim-nightly, ... }@inputs:

    let
      hostPlatform = "x86_64-linux";

      overlays = {
        neovim-nightly = neovim-nightly.overlay;
      };

      pkgs = import nixpkgs {
        inherit hostPlatform;
        overlays = builtins.attrValues overlays;
        config.allowUnfree = true;
      };
    in

    rec {
      nixosConfigurations = {
        nixosWSL = nixpkgs.lib.nixosSystem {
          inherit pkgs;
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

      devShells.${hostPlatform}.default = import ./shell.nix { inherit pkgs; };
    };
}
