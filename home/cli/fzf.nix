{ config, ... }:

{
  programs = {
    fzf = rec {
      enable = true;
      defaultCommand = "fd --type f";
      defaultOptions = [ "--height 50%" ];
      fileWidgetCommand = "${defaultCommand}";
      fileWidgetOptions = [
        "--preview 'bat --color=always --plain --line-range=:200 {}'"
      ];
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [
        "--preview 'exa --tree --icons | head -200'"
      ];
      historyWidgetOptions = [ ];
    };

    fish.interactiveShellInit = with config.colors; ''
      set -gx FZF_DEFAULT_OPTS "\
        --color=fg:${foreground},bg:${background},hl:${purple} \
        --color=fg+:${foreground},bg+:${selection},hl+:${purple} \
        --color=info:${orange},prompt:${green},pointer:${pink} \
        --color=marker:${pink},spinner:${orange},header:${comment}"
    '';
  };
}
