{ config, ... }:

{
  programs.starship = {
    enable = true;

    settings = with config.colors; {
      username.format = "[$user]($style) on ";
      character.success_symbol = "[❱](bold ${foreground})";
      character.error_symbol = "[❱](bold ${red})";

      # Colors
      aws.style = "bold ${orange}";
      cmd_duration.style = "bold ${yellow}";
      directory.style = "bold ${green}";
      hostname.style = "bold ${red}";
      git_branch.style = "bold ${pink}";
      git_status.style = "bold ${red}";
      username.style_user = "bold ${purple}";

      # Nerd Font Symbols
      aws.symbol = " ";
      buf.symbol = " ";
      c.symbol = " ";
      conda.symbol = " ";
      dart.symbol = " ";
      directory.read_only = " ";
      docker_context.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";
      git_branch.symbol = " ";
      golang.symbol = " ";
      haskell.symbol = " ";
      hg_branch.symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      memory_usage.symbol = " ";
      nim.symbol = " ";
      nix_shell.symbol = " ";
      nodejs.symbol = " ";
      package.symbol = " ";
      python.symbol = " ";
      spack.symbol = "🅢 ";
      rust.symbol = " ";
    };
  };
}
