{ pkgs, ... }:

{
  programs.exa.enable = true;

  programs.fish.shellAliases = {
    ls = "${pkgs.exa}/bin/exa --icons";
    ll = "${pkgs.exa}/bin/exa -l --icons";
    la = "${pkgs.exa}/bin/exa -a --icons";
    lt = "${pkgs.exa}/bin/exa --tree --icons";
    lla = "${pkgs.exa}/bin/exa -la --icons";
  };
}
