{
  imports = [
    ./bat.nix
    ./catppuccin.nix
    ./cli.nix
    ./git.nix
    ./home.nix
    ./nh.nix
    ./nix.nix
    ./nixcats-neovim.nix
    ./shell.nix
    ./skim.nix
    ./tealdeer.nix
  ];

  boot.tmp.cleanOnBoot = true;

  system.stateVersion = "25.05";
}
