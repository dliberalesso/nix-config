{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  allowed-users = [ "@wheel" ];
  trusted-users = allowed-users;
in
{
  nix = {
    package = inputs.nix.packages.${pkgs.system}.nix;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # Make nix3 and legacy nix commands consistent:
    # - Add the inputs to the system's legacy channels
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    # - Add each flake input as a registry
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    settings = {
      inherit allowed-users trusted-users;

      always-allow-substitutes = true;

      auto-optimise-store = true;

      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];

      lazy-trees = true;

      substituters = [
        "https://dliberalesso.cachix.org"
        "https://catppuccin.cachix.org"
        "https://hyprland.cachix.org"
        "https://cachix.cachix.org"
        "https://nix-community.cachix.org"
        "https://install.determinate.systems"
      ];

      trusted-public-keys = [
        "dliberalesso.cachix.org-1:7qs1S5Qd766dYFU86nVux/wRMZ8UEUbhn3Qxp/TwiOc="
        "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      ];
    };
  };
}
