{
  imports = [
    ./nixcats-neovim

    ./bat.nix
    ./catppuccin.nix
    ./cli.nix
    ./git.nix
    ./home.nix
    ./nh.nix
    ./nix.nix
    ./shell.nix
    ./skim.nix
    ./tealdeer.nix
  ];

  boot.tmp.cleanOnBoot = true;

  system = {
    rebuild.enableNg = true;
    stateVersion = "25.05";
  };
}
