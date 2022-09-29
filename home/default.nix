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
  home.packages = with pkgs; [
    fd
    grex
    hyperfine
    sd
    ripgrep
    tokei
    wget
  ];

  programs = {
    bat.enable = true;
    bottom.enable = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    exa.enable = true;
    fish.enable = true;
    gh.enable = true;
    git.enable = true;
    git.delta.enable = true;
    lazygit.enable = true;
    neovim.enable = true;
    skim.enable = true;
    starship.enable = true;
    tealdeer.enable = true;
    zoxide.enable = true;
  };

  # Services
  services.vscode-server.enable = true;
  systemd.user.startServices = "sd-switch"; # Reload system units on config change
}
