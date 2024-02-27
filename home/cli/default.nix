{ pkgs, ... }:

{
  imports = [
    ./bat.nix
    ./eza.nix
    ./fzf.nix
    ./tealdeer.nix
  ];

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
    bottom.enable = true;
  };
}
