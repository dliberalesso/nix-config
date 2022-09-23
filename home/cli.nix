{ lib, ... }:

{
  programs = {
    bat.config = {
      color = "always";
      pager = "less";
    };

    fish = {
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

    fzf = rec {
      defaultCommand = "fd --type f";
      defaultOptions = [ "--height 50%" ];

      fileWidgetCommand = "${defaultCommand}";
      fileWidgetOptions = [
        "--preview 'bat --plain --line-range=:200 {}'"
      ];

      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [
        "--preview 'exa --tree --icons | head -200'"
      ];

      historyWidgetOptions = [ ];
    };
  };

  home.activation.tealdeer = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD tldr --update $VERBOSE_ARG
  '';
}
