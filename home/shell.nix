{
  programs = {
    fish = {
      enable = true;

      interactiveShellInit = ''
        set -g fish_greeting
        set -gx fish_term24bit 1
        set -gx COLORTERM truecolor
      '';
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    starship = {
      enable = true;

      settings = {
        # Format
        username.format = "[$user]($style) on ";

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

    zoxide = {
      enable = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
