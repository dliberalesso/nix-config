{pkgs, ...}: {
  programs.eza.enable = true;

  programs.fish.shellAliases = rec {
    ls = "${pkgs.eza}/bin/eza --icons";
    ll = "${ls} -l";
    la = "${ls} -a";
    lt = "${ls} --tree";
    lla = "${ls} -la";
  };
}
