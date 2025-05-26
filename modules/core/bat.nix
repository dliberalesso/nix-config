{
  hm,
  pkgs,
  ...
}:
hm {
  home.sessionVariables = {
    BATDIFF_USE_DELTA = "true";
  };

  programs.bat = {
    enable = true;

    config = {
      color = "always";
      pager = "less -FR";
    };

    extraPackages = with pkgs.bat-extras; [
      batdiff
      batgrep
      batman
      batpipe
      batwatch
      prettybat
    ];
  };
}
