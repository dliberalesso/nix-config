{ inputs
, lib
, pkgs
, ...
}: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin

    ./catppuccin.nix
    ./cli.nix
    ./git.nix
    ./shell.nix

    inputs.nixvim.homeManagerModules.nixvim
    ../../nixvim
  ];

  # Home Manager
  programs.home-manager.enable = true;
  xdg.enable = true;

  home = rec {
    username = "dli50";
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  # Packages & Programs
  home.packages = with pkgs; [ cachix ];

  # Services
  systemd.user.startServices = "sd-switch"; # Reload system units on config change
}
