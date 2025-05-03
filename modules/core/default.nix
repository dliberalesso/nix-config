{
  imports = [
    ./bat.nix
    ./catppuccin.nix
    ./cli.nix
    ./fzf.nix
    ./git.nix
    ./home.nix
    ./nix.nix
    ./nixcats-neovim.nix
    ./shell.nix
    ./tealdeer.nix
  ];

  boot.tmp.cleanOnBoot = true;

  system.stateVersion = "25.05";
}
