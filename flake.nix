{
  description = "My NixOS config";

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree [
        ./hosts
        ./modules
      ]
    );

  nixConfig = {
    always-allow-substitutes = true;

    extra-substituters = [
      "https://dliberalesso.cachix.org"
      "https://nix-community.cachix.org"
      "https://cachix.cachix.org"
      "https://cache.numtide.com"
      "https://catppuccin.cachix.org"
    ];

    extra-trusted-public-keys = [
      "dliberalesso.cachix.org-1:7qs1S5Qd766dYFU86nVux/wRMZ8UEUbhn3Qxp/TwiOc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
    ];
  };

  inputs = {
    nixpkgs.follows = "llm-agents/nixpkgs";

    bun2nix = {
      url = "github:nix-community/bun2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
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
        flake-compat.follows = "flake-compat";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs = {
        bun2nix.follows = "bun2nix";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    make-shell = {
      url = "github:nicknovitski/make-shell";
      inputs.flake-compat.follows = "flake-compat";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    systems.url = "github:nix-systems/default";

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

    # Neovim plugins

    plugins-jj-diffconflicts = {
      url = "github:rafikdraoui/jj-diffconflicts";
      flake = false;
    };

    plugins-wezterm-types = {
      url = "github:gonstoll/wezterm-types";
      flake = false;
    };
  };
}
