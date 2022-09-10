{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    plugins = with pkgs; [
      {
        name = "tide";
        src = fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "v5.5.0";
          sha256 = "ilPHBSaIuGqsbJkTXXsnz7Fb9VyI7PQyirTi/cyXh90=";
        };
      }
    ];

    interactiveShellInit = ''
      set -g fish_greeting

      # Dracula PRO - Van Helsing
      set -l foreground f8f8f2
      set -l selection 414d58
      set -l comment 708ca9
      set -l red ff9580
      set -l orange ffca80
      set -l yellow ffff80
      set -l green 8aff80
      set -l purple 9580ff
      set -l cyan 80ffea
      set -l pink ff80bf

      # Syntax Highlighting Colors
      set -gx fish_color_normal $foreground
      set -gx fish_color_command $cyan
      set -gx fish_color_keyword $pink
      set -gx fish_color_quote $yellow
      set -gx fish_color_redirection $foreground
      set -gx fish_color_end $orange
      set -gx fish_color_error $red
      set -gx fish_color_param $purple
      set -gx fish_color_comment $comment
      set -gx fish_color_selection --background=$selection
      set -gx fish_color_search_match --background=$selection
      set -gx fish_color_operator $green
      set -gx fish_color_escape $pink
      set -gx fish_color_autosuggestion $comment
      set -gx fish_color_cancel $red --reverse
      set -gx fish_color_option $orange

      # Default Prompt Colors
      set -gx fish_color_cwd $green
      set -gx fish_color_host $purple
      set -gx fish_color_host_remote $purple
      set -gx fish_color_user $cyan

      # Completion Pager Colors
      set -gx fish_pager_color_progress $comment
      set -gx fish_pager_color_background
      set -gx fish_pager_color_prefix $cyan
      set -gx fish_pager_color_completion $foreground
      set -gx fish_pager_color_description $comment
      set -gx fish_pager_color_selected_background --background=$selection
      set -gx fish_pager_color_selected_prefix $cyan
      set -gx fish_pager_color_selected_completion $foreground
      set -gx fish_pager_color_selected_description $comment
      set -gx fish_pager_color_secondary_background
      set -gx fish_pager_color_secondary_prefix $cyan
      set -gx fish_pager_color_secondary_completion $foreground
      set -gx fish_pager_color_secondary_description $comment
    '';
  };
}
