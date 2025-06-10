{
  inputs,
  ...
}:
{
  imports =
    [
      ./nixcats-neovim

      ./catppuccin.nix
      ./git.nix
      ./home.nix
      ./nh.nix
      ./nix.nix
    ]
    ++ map inputs.import-tree [
      ./cli
      ./shell
    ];

  boot.tmp.cleanOnBoot = true;

  system.rebuild.enableNg = true;
}
