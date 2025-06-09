{
  inputs,
  ...
}:
{
  imports =
    [
      ./nixcats-neovim

      ./catppuccin.nix
      ./home.nix
      ./nh.nix
      ./nix.nix
    ]
    ++ map inputs.import-tree [
      ./cli
      ./shell
      ./vcs
    ];

  boot.tmp.cleanOnBoot = true;

  system.rebuild.enableNg = true;
}
