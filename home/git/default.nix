{ ... }:

{
  imports = [
    ./delta.nix
    ./git.nix
    ./lazygit.nix
  ];

  programs = {
    gh.enable = true;
  };
}
