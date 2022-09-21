{ lib, ... }:

with lib;

{
  programs = mkMerge [
    (attrsets.genAttrs [
      "bat"                 # Cat with syntax highlighting
      "bottom"              # Process/system monitor
      "direnv"              # Shell extension that manages environment
      "exa"                 # Replacement for 'ls' written in Rust
      "fish"                # Command-line shell
      "fzf"                 # Command-line fuzzy finder
      "tealdeer"            # TLDR for man pages
      "zoxide"              # cd command
    ] (name: { enable = true; }))

    {
      bat.config = {
        color = "always";
        pager = "less";
      };

      direnv.nix-direnv.enable = true;

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
    }
  ];

  home.activation.tealdeer = hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD tldr --update $VERBOSE_ARG
  '';
}
