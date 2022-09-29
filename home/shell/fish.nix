{ ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting
      set -gx fish_term24bit 1
      set -gx COLORTERM truecolor
    '';
  };
}
