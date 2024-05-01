{ pkgs, ... }:

{
  imports = [
    ./bat.nix
    ./eza.nix
    ./fzf.nix
    ./tealdeer.nix
  ];

  home.packages = with pkgs; [
    devenv
    fd
    grex
    hyperfine
    sd
    tokei
    wget
  ];

  programs = {
    bottom.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
  };
}
