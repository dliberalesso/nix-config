{
  imports = [
    ./nixcats-neovim

    ./bat.nix
    ./catppuccin.nix
    ./cli.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./home.nix
    ./nh.nix
    ./nix-index-database.nix
    ./nix.nix
    ./shell.nix
    ./tealdeer.nix
    ./uutils-coreutils.nix
  ];

  boot.tmp.cleanOnBoot = true;

  system.rebuild.enableNg = true;
}
