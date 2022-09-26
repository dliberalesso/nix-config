{ inputs, lib, pkgs, config, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/profiles/minimal.nix"

    inputs.nixos-wsl.nixosModules.wsl
  ];

  nix = {
    # Make nix3 and legacy nix commands consistent:
    # # Add each flake input as a registry
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    # # Add the inputs to the system's legacy channels
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # No graphical stuff please!
  environment.noXlibs = lib.mkOverride 0 true;
  hardware.opengl.enable = lib.mkOverride 0 false;

  # Setup WSL
  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "dli";
    startMenuLaunchers = false;
    wslConf.network.hostname = "nixos-wsl";
  };

  # Fish
  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.05";

  # Create a list of all packages and their versions
  environment.etc."current-system-packages".text =
    let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
    formatted;
}
