{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    inputs.vscode-server.nixosModules.home
  ];

  nixpkgs.config.allowUnfree = true;

  home = rec {
    username = "dli";
    homeDirectory = "/home/${username}";
  };

  # programs.neovim.enable = true;
  home.packages = with pkgs; [ wget ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  services.vscode-server.enable = true;
  
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
