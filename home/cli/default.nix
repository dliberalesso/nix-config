{ inputs, ... }:

{
  imports = [
    ./exa.nix
    ./fish.nix
    ./fzf.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish.shellAliases = {
    hms = "home-manager switch --flake .";
  };
}
