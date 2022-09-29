{ inputs, pkgs, ... }:

{
  imports = [
    ./cli
    ./git
    ./neovim
    ./shell
    ./theme

    inputs.vscode-server.nixosModules.home
  ];

  # Home Manager
  programs.home-manager.enable = true;

  home = rec {
    username = "dli";
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";
  };

  # Packages & Programs
  home.packages = with pkgs; [ ];
  programs = { };

  # Services
  services.vscode-server.enable = true;
  systemd.user.startServices = "sd-switch"; # Reload system units on config change
}
