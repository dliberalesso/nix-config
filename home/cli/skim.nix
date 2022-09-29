{ ... }:

{
  programs.skim = rec {
    enable = true;

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
}
