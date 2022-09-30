{ pkgs, ... }:

{
  programs.exa.enable = true;

  programs.fish.shellAliases = rec {
    ls = "${pkgs.exa}/bin/exa --icons";
    ll = "${ls} -l";
    la = "${ls} -a";
    lt = "${ls} --tree";
    lla = "${ls} -la";
  };
}
