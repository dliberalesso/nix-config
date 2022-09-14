{ inputs, ... }:

{
  imports = [
    ./exa.nix
    ./fish.nix
    ./fzf.nix
  ];

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };
}
