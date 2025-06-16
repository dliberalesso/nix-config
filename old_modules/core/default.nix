{
  inputs,
  ...
}:
{
  imports = [
    ./nixcats-neovim

    ./catppuccin.nix
    ./git.nix
    ./home.nix
    ./jujutsu.nix
    ./nh.nix
    ./nix.nix

    (inputs.import-tree [
      ./cli
      ./shell
    ])
  ];

  boot.tmp.cleanOnBoot = true;

  system.rebuild.enableNg = true;
}
