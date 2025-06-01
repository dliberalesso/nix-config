{
  imports = [
    ./nixcats-neovim

    ./bat.nix
    ./catppuccin.nix
    ./cli.nix
    ./fzf.nix
    ./git.nix
    ./home.nix
    ./nh.nix
    ./nix.nix
    ./shell.nix
    ./tealdeer.nix
  ];

  boot.tmp.cleanOnBoot = true;

  system = {
    rebuild.enableNg = true;
    switch.enableNg = true;
  };
}
