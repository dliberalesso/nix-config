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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-root.url = "github:srid/flake-root";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        # flake-compat.follows = "dedupe-flake-compat";
      };
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        ags.follows = "dedupe-ags";
        astal.follows = "dedupe-astal";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        # flake-compat.follows = "dedupe-flake-compat";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
        hercules-ci-effects.follows = "";
        # hercules-ci-effects.follows = "dedupe-hercules-ci-effects";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix = {
      url = "github:DeterminateSystems/nix-src";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        git-hooks-nix.follows = "git-hooks";
      };
    };

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        # flake-compat.follows = "dedupe-flake-compat";
      };
    };

    plugins-wezterm-types = {
      url = "github:gonstoll/wezterm-types";
      flake = false;
    };

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    unify = {
      url = "git+https://codeberg.org/quasigod/unify.git";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
      };
    };

    dedupe-ags = {
      url = "github:aylur/ags";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        astal.follows = "dedupe-astal";
      };
    };

    dedupe-astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # dedupe-flake-compat = {
    #   url = "github:edolstra/flake-compat";
    #   flake = false;
    # };

    # dedupe-hercules-ci-effects = {
    #   url = "github:hercules-ci/hercules-ci-effects";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-parts.follows = "flake-parts";
    #   };
    # };
  };
}
