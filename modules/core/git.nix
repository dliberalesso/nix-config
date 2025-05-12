{
  home-manager.users.dli50.programs = {
    git = {
      enable = true;
      delta.enable = true;

      userName = "Douglas Liberalesso";
      userEmail = "dliberalesso@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        url."https://github.com/".insteadOf = "git://github.com/";
      };

      lfs.enable = true;

      ignores = [
        ".direnv"
        "result"
      ];
    };

    gh.enable = true;

    jujutsu.enable = true;

    lazygit = {
      enable = true;

      settings = {
        git = {
          paging = {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          };
        };

        update = {
          method = "never";
        };
      };
    };
  };
}
