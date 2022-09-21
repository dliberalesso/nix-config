{ config, lib, ... }:

with config.theme;
with config.theme.colors;

# Let's theme the **** out of this!

{
  imports = [
    ./colors.nix
    ./options.nix
  ];

  theme.tmTheme = builtins.readFile ./assets/tmTheme/${variant}.tmTheme;

  # Bat
  programs.bat = {
    config.theme = variant;
    themes.${variant} = tmTheme;
  };

  home.activation.bat = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    $DRY_RUN_CMD bat cache --build $VERBOSE_ARG
  '';

  # Delta
  programs.git.delta.options = {
    syntax-theme = variant;
    minus-emph-style = "syntax ${dracula_pro_base.selection}";
    minus-style = "syntax ${dracula_pro_morbius.selection}";
    plus-emph-style = "syntax ${dracula_pro_base.selection}";
    plus-style = "syntax ${dracula_pro_blade.selection}";
  };

  # Fish & FZF
  programs.fish.interactiveShellInit = ''
    set -gx FZF_DEFAULT_OPTS "\
      --color=fg:${foreground},bg:${background},hl:${purple} \
      --color=fg+:${foreground},bg+:${selection},hl+:${purple} \
      --color=info:${orange},prompt:${green},pointer:${pink} \
      --color=marker:${pink},spinner:${orange},header:${comment}"
      
    # Syntax Highlighting Colors
    set -gx fish_color_normal \${foreground}
    set -gx fish_color_command \${cyan}
    set -gx fish_color_keyword \${pink}
    set -gx fish_color_quote \${yellow}
    set -gx fish_color_redirection \${foreground}
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
    set -gx fish_pager_color_completion \${foreground}
    set -gx fish_pager_color_description \${comment}
    set -gx fish_pager_color_selected_background --background=\${selection}
    set -gx fish_pager_color_selected_prefix \${cyan}
    set -gx fish_pager_color_selected_completion \${foreground}
    set -gx fish_pager_color_selected_description \${comment}
    set -gx fish_pager_color_secondary_background
    set -gx fish_pager_color_secondary_prefix \${cyan}
    set -gx fish_pager_color_secondary_completion \${foreground}
    set -gx fish_pager_color_secondary_description \${comment}
  '';

  # Starship
  programs.starship.settings = {
    character.success_symbol = "[❱](bold ${foreground})";
    character.error_symbol = "[✗](bold ${red})";

    aws.style = "bold ${orange}";
    cmd_duration.style = "bold ${yellow}";
    directory.style = "bold ${green}";
    hostname.style = "bold ${red}";
    git_branch.style = "bold ${pink}";
    git_status.style = "bold ${red}";
    username.style_user = "bold ${purple}";
  };
}
