{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ../../modules/catppuccin.nix

    ./bat.nix
    ./cli.nix
    ./git.nix
    ./nixcats-neovim.nix
    ./shell.nix
    ./tealdeer.nix
  ];

  # Home Manager
  programs.home-manager.enable = true;
  xdg.enable = true;

  home = rec {
    username = "dli50";
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # Packages & Programs
  home.packages = with pkgs; [
    cachix
  ];

  # Services
  systemd.user.startServices = "sd-switch"; # Reload system units on config change
}
