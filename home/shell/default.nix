{...}: {
  imports = [
    ./fish.nix
    ./starship.nix
    ./zoxide.nix
  ];

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };
}
