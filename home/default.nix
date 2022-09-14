{ inputs, pkgs, ... }:

{
  imports = [
    ./cli
    ./colors.nix
    ./git.nix

    inputs.vscode-server.nixosModules.home
  ];

  nixpkgs.config.allowUnfree = true;

  home = rec {
    username = "dli";
    homeDirectory = "/home/${username}";
  };

  # Programs
  programs.home-manager.enable = true;
  # programs.neovim.enable = true;

  # pkgs
  home.packages = with pkgs; [ wget ];

  # Services
  services.vscode-server.enable = true;
  systemd.user.startServices = "sd-switch"; # Reload system units on config change

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
