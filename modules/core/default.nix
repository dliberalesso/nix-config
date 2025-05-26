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

  programs = {
    skim.enable = true;
  };

  system.rebuild.enableNg = true;
}
