{
  unify.home =
    {
      config,
      ...
    }:
    {
      home.shell.enableZshIntegration = true;

      programs.zsh = {
        enable = true;

        autosuggestion = {
          enable = true;

          strategy = [
            "history"
            "completion"
          ];
        };

        dotDir = "${config.xdg.configHome}/zsh";

        history.expireDuplicatesFirst = true;

        historySubstringSearch.enable = true;

        syntaxHighlighting.enable = true;
      };
    };

  unify.nixos =
    {
      lib,
      pkgs,
      ...
    }:
    {
      programs.zsh = {
        enable = true;

        autosuggestions = {
          enable = true;

          strategy = [
            "history"
            "completion"
          ];
        };

        compInitDumpFile = "$XDG_CACHE_HOME/zsh/zcompdump";

        histFile = "$XDG_CONFIG_HOME/zsh/.zsh_history";

        # Load zsh-history-substring-search after zsh-syntax-highlighting
        # https://github.com/zsh-users/zsh-history-substring-search#usage
        interactiveShellInit = lib.mkOrder 1600 ''
          source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

          bindkey '^[[A' history-substring-search-up
          bindkey '^[[B' history-substring-search-down
        '';

        setOptions = [
          "HIST_FCNTL_LOCK"
          "HIST_IGNORE_DUPS"
          "HIST_IGNORE_SPACE"
          "HIST_EXPIRE_DUPS_FIRST"
          "SHARE_HISTORY"
          "NO_APPEND_HISTORY"
          "NO_HIST_IGNORE_ALL_DUPS"
          "NO_HIST_SAVE_NO_DUPS"
          "NO_HIST_FIND_NO_DUPS"
          "NO_EXTENDED_HISTORY"
        ];

        syntaxHighlighting.enable = true;
      };

      users.defaultUserShell = pkgs.zsh;
    };
}
