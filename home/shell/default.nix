{ ... }:

{
  imports = [
    ./fish.nix
    ./starship.nix
  ];

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    
    zoxide = {
      enable = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
