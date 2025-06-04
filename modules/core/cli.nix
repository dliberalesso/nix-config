{
  hm,
  pkgs,
  ...
}:
{

  programs.bandwhich.enable = true;
}
// hm {
  home.packages = with pkgs; [
    dust
    grex
    httpie
    hyperfine
    lazysql
    lnav
    procs
    sd
    tokei
    trash-cli
    wget
  ];

  programs = {
    bottom.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
    yazi.enable = true;
  };
}
