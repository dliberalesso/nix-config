{ lib, ... }:

{
  programs = {
    bat.config = {
      color = "always";
      pager = "less";
    };

    skim = rec {
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
