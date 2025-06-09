{
  inputs,
  ...
}:
{
  imports = [
    ./nixcats-neovim

    (inputs.import-tree ./shell)

    ./bat.nix
    ./catppuccin.nix
    ./cli.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./home.nix
    ./lazygit.nix
    ./nh.nix
    ./nix.nix
    ./tealdeer.nix
    ./uutils-coreutils.nix
  ];

  boot.tmp.cleanOnBoot = true;

  system.rebuild.enableNg = true;
}
