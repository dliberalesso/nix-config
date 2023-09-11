{ config, lib, ... }:

{
  programs.skim = rec {
    enable = true;

    defaultCommand = "fd --type f";
    defaultOptions = with config.theme.colors; [
      (lib.concatStrings [
        "--color="
        "fg:${fg},bg:${bg},hl:${purple},"
        "fg+:${fg},bg+:${selection},hl+:${purple},"
        "info:${orange},prompt:${green},pointer:${pink},"
        "marker:${pink},spinner:${orange},header:${comment}"
      ])

      "--height 50%"
    ];

    fileWidgetCommand = "${defaultCommand}";
    fileWidgetOptions = [
      "--preview 'bat --plain --line-range=:200 {}'"
    ];

    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [
      "--preview 'eza --tree --icons | head -200'"
    ];

    historyWidgetOptions = [ ];
  };
}
