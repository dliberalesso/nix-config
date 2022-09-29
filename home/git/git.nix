{ ... }:

{
  programs = {
    git = {
      userName = "Douglas Liberalesso";
      userEmail = "dliberalesso@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";
        url."https://github.com/".insteadOf = "git://github.com/";
      };

      lfs.enable = true;

      ignores = [ ".direnv" "result" ];
    };

    lazygit = {
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
