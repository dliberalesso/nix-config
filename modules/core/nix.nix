{
  config,
  inputs,
  lib,
  ...
}:
{
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
      extra-substituters = [
        "https://dliberalesso.cachix.org"
        "https://catppuccin.cachix.org"
        "https://hyprland.cachix.org"
        "https://cachix.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      extra-trusted-public-keys = [
        "dliberalesso.cachix.org-1:7qs1S5Qd766dYFU86nVux/wRMZ8UEUbhn3Qxp/TwiOc="
        "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      # Required by Cachix to be used as non-root user
      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = [ "@wheel" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
