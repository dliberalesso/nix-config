{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    ../../modules/catppuccin.nix

    ./cli.nix
    ./git.nix
    ./shell.nix

    ../programs/nixcats-neovim.nix
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
  home.packages = with pkgs; [
    cachix
  ];

  # Services
  systemd.user.startServices = "sd-switch"; # Reload system units on config change
}
