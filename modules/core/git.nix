{
  hm,
  user,
  ...
}:
hm {
  programs = {
    gh.enable = true;

    git = {
      enable = true;

      delta.enable = true;

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        url."https://github.com/".insteadOf = "git://github.com/";
      };

      ignores = [
        ".direnv"
        "result"
      ];

      lfs.enable = true;

      userName = user.name;
      userEmail = user.email;
    };

    lazygit = {
      enable = true;

      settings = {
        git.paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };

        os.editPreset = "nvim-remote";

        update.method = "never";
      };
    };
  };
}
