{ ... }:

{
  programs.exa.enable = true;

  programs.fish.shellAliases = {
    ls = "exa --icons";
    ll = "exa -l --icons";
    la = "exa -a --icons";
    lt = "exa --tree --icons";
    lla = "exa -la --icons";
  };
}
