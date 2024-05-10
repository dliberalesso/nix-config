{config, ...}: let
  syntax-theme = config.theme.name;
  selection = config.theme.colors.selection;
in {
  programs.git.delta = {
    enable = true;

    options = {
      inherit syntax-theme;
      minus-emph-style = "syntax ${selection}";
      minus-style = "syntax #584145";
      plus-emph-style = "syntax ${selection}";
      plus-style = "syntax #415854";
    };
  };
}
