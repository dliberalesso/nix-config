{config, ...}: {
  programs.fish = {
    enable = true;

    interactiveShellInit = with config.theme.colors; ''
      set -g fish_greeting
      set -gx fish_term24bit 1
      set -gx COLORTERM truecolor

      # Syntax Highlighting Colors
      set -gx fish_color_normal \${fg}
      set -gx fish_color_command \${cyan}
      set -gx fish_color_keyword \${pink}
      set -gx fish_color_quote \${yellow}
      set -gx fish_color_redirection \${fg}
      set -gx fish_color_end \${orange}
      set -gx fish_color_error \${red}
      set -gx fish_color_param \${purple}
      set -gx fish_color_comment \${comment}
      set -gx fish_color_selection --background=\${selection}
      set -gx fish_color_search_match --background=\${selection}
      set -gx fish_color_operator \${green}
      set -gx fish_color_escape \${pink}
      set -gx fish_color_autosuggestion \${comment}
      set -gx fish_color_cancel \${red} --reverse
      set -gx fish_color_option \${orange}

      # Default Prompt Colors
      set -gx fish_color_cwd \${green}
      set -gx fish_color_host \${purple}
      set -gx fish_color_host_remote \${purple}
      set -gx fish_color_user \${cyan}

      # Completion Pager Colors
      set -gx fish_pager_color_progress \${comment}
      set -gx fish_pager_color_background
      set -gx fish_pager_color_prefix \${cyan}
      set -gx fish_pager_color_completion \${fg}
      set -gx fish_pager_color_description \${comment}
      set -gx fish_pager_color_selected_background --background=\${selection}
      set -gx fish_pager_color_selected_prefix \${cyan}
      set -gx fish_pager_color_selected_completion \${fg}
      set -gx fish_pager_color_selected_description \${comment}
      set -gx fish_pager_color_secondary_background
      set -gx fish_pager_color_secondary_prefix \${cyan}
      set -gx fish_pager_color_secondary_completion \${fg}
      set -gx fish_pager_color_secondary_description \${comment}
    '';
  };
}
