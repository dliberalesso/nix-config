{ config, ... }:

{
  programs.fzf.enable = true;

  programs.fish.interactiveShellInit = with config.colors; ''
    set -Ux FZF_DEFAULT_OPTS "\
      --color=fg:${foreground},bg:${background},hl:${purple} \
      --color=fg+:${foreground},bg+:${selection},hl+:${purple} \
      --color=info:${orange},prompt:${green},pointer:${pink} \
      --color=marker:${pink},spinner:${orange},header:${comment}"
  '';
}
