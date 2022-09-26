{ config, lib, pkgs, ... }:

# Let's theme the **** out of this!

let
  cfg = config.programs;

  background = "#282a36";
  selection = "#44475a";
  foreground = "#f8f8f2";
  comment = "#6272a4";
  cyan = "#8be9fd";
  green = "#50fa7b";
  orange = "#ffb86c";
  pink = "#ff79c6";
  purple = "#bd93f9";
  red = "#ff5555";
  yellow = "#f1fa8c";
in

with lib;

{
  config.programs = {
    bat.config.theme = mkIf cfg.bat.enable "Dracula";

    git.delta.options = mkIf cfg.git.delta.enable {
      syntax-theme = "Dracula";
      minus-emph-style = "syntax ${selection}";
      minus-style = "syntax #584145";
      plus-emph-style = "syntax ${selection}";
      plus-style = "syntax #415854";
    };

    fish.interactiveShellInit = mkIf cfg.fish.enable ''
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

    neovim = mkIf cfg.neovim.enable {
      extraConfig = ''
        colorscheme dracula
      '';

      plugins = with pkgs.vimPlugins; [
        dracula-vim
      ];
    };

    skim.defaultOptions = mkIf cfg.skim.enable [
      (concatStrings [
        "--color="
        "fg:${foreground},bg:${background},hl:${purple},"
        "fg+:${foreground},bg+:${selection},hl+:${purple},"
        "info:${orange},prompt:${green},pointer:${pink},"
        "marker:${pink},spinner:${orange},header:${comment}"
      ])
    ];

    starship.settings = mkIf cfg.starship.enable {
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
  };
}
