{ inputs
, pkgs
, ...
}: {
  imports = [
    inputs.vscode-server.nixosModules.home
    inputs.catppuccin.homeManagerModules.catppuccin

    ./catppuccin.nix
    ./cli.nix
    ./git.nix
    ./shell.nix
  ];

  # Home Manager
  programs.home-manager.enable = true;
  xdg.enable = true;

  home = rec {
    username = "dli";
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";
  };

  # Packages & Programs
  home.packages = with pkgs; [
    cachix
    nvim-with-aliases
  ];

  # Services
  services.vscode-server.enable = true;
  systemd.user.startServices = "sd-switch"; # Reload system units on config change
}
