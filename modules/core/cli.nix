{
  hm,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.uutils-coreutils-noprefix
  ];

  programs.bandwhich.enable = true;
}
// hm {
  home.packages = with pkgs; [
    dust
    grex
    httpie
    fselect
    hyperfine
    lazysql
    lnav
    presenterm
    procs
    sd
    tokei
    trash-cli
    wget
    xh
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
