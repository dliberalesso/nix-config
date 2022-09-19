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

      delta = {
        enable = true;

        options = {
          syntax-theme = "dracula_pro";
          minus-emph-style = "syntax #454158";
          minus-style = "syntax #584145";
          plus-emph-style = "syntax #454158";
          plus-style = "syntax #415854";
        };
      };

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
