{ ... }:

{
  programs = {
    gh.enable = true;

    git = {
      enable = true;

      userName = "Douglas Liberalesso";
      userEmail = "dliberalesso@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";
        url."https://github.com/".insteadOf = "git://github.com/";
      };

      delta.enable = true;
      lfs.enable = true;

      ignores = [ ".direnv" "result" ];
    };

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
