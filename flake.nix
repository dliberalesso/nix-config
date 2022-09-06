{
  description = "My NixOS & Home-Manager config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";    
  };

  outputs = { nixpkgs, nixos-wsl, ... }@inputs: {
    nixosConfigurations = {
      winavell = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./winavell.nix ];
      };
    };
  };
}
