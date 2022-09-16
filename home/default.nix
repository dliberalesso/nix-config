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

    packages = with pkgs; [
      fd          # Alternative to find
      grex        # Tool for generating regex
      hyperfine   # Benchmarking
      sd          # A better sed
      ripgrep     # A better grep
      tokei       # Code statistics
      wget        # Retrieve files using HTTP, HTTPS, and FTP
    ];

    stateVersion = "22.05";
  };

  # Home Manager
  programs.home-manager.enable = true;

  # Services
  services.vscode-server.enable = true;
  systemd.user.startServices = "sd-switch"; # Reload system units on config change
}
