{ pkgs, ... }:

{
  imports = [
    ./bat.nix
    ./exa.nix
    ./skim.nix
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
