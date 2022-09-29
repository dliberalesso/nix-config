{
  programs.fish = {
    interactiveShellInit = ''
      set -g fish_greeting
      set -gx fish_term24bit 1
      set -gx COLORTERM truecolor
    '';

    shellAliases = {
      ls = "exa --icons";
      ll = "exa -l --icons";
      la = "exa -a --icons";
      lt = "exa --tree --icons";
      lla = "exa -la --icons";
    };
  };
}
