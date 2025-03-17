{ inputs
, lib
, pkgs
, config
, ...
}: {
  nix = {
    # Make nix3 and legacy nix commands consistent:
    # - Add each flake input as a registry
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    # - Add the inputs to the system's legacy channels
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      # Cache
      substituters = [
        "https://cachix.cachix.org"
        "https://nix-community.cachix.org"
        "https://dliberalesso.cachix.org"
      ];
      trusted-public-keys = [
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "dliberalesso.cachix.org-1:7qs1S5Qd766dYFU86nVux/wRMZ8UEUbhn3Qxp/TwiOc="
      ];

      # Required by Cachix to be used as non-root user
      trusted-users = [ "root" "@wheel" ];
      allowed-users = [ "@wheel" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  boot.tmp.cleanOnBoot = true;

  # Fish
  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # There is a problem with programs.sqlite
  programs.command-not-found.enable = lib.mkOverride 0 false;

  system.stateVersion = "25.05";
}
