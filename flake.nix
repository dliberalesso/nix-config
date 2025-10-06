{
  description = "NixForge: My NixOS config";

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree [
        ./hosts
        ./modules
      ]
    );

  inputs = {
    nix-proxy-flake.url = "github:dliberalesso/nix-proxy-flake";

    # Eval-time inputs

    nixpkgs.follows = "nix-proxy-flake/nixpkgs";

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nix-proxy-flake/nixpkgs";
    };

    flake-parts.follows = "nix-proxy-flake/flake-parts";

    flake-root.follows = "nix-proxy-flake/flake-root";

    git-hooks.follows = "nix-proxy-flake/git-hooks";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nix-proxy-flake/nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    make-shell = {
      url = "github:nicknovitski/make-shell";
      inputs.flake-compat.follows = "nix-proxy-flake/flake-compat";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nix-proxy-flake/nixpkgs";
    };

    nix-src.follows = "nix-proxy-flake/nix-src";

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nix-proxy-flake/nixpkgs";
        flake-compat.follows = "nix-proxy-flake/flake-compat";
      };
    };

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nix-proxy-flake/nixpkgs";
    };

    treefmt-nix.follows = "nix-proxy-flake/treefmt-nix";

    unify = {
      url = "git+https://codeberg.org/quasigod/unify.git";
      inputs = {
        nixpkgs.follows = "nix-proxy-flake/nixpkgs";
        flake-parts.follows = "nix-proxy-flake/flake-parts";
        home-manager.follows = "home-manager";
      };
    };

    # Build-time inputs

    npins = {
      url = "github:andir/npins";
      flake = false;
      buildTime = true;
    };

    ## Neovim plugins

    plugins-jj-diffconflicts = {
      url = "github:rafikdraoui/jj-diffconflicts";
      flake = false;
      buildTime = true;
    };

    plugins-wezterm-types = {
      url = "github:gonstoll/wezterm-types";
      flake = false;
      buildTime = true;
    };
  };
}
