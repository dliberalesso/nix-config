{
  lib,
  pkgs,
  ...
}:
{
  programs = {
    bandwhich.enable = true;

    # There is a problem with programs.sqlite
    command-not-found.enable = lib.mkOverride 0 false;
  };

  home-manager.users.dli50 = {
    home.packages = with pkgs; [
      dust
      grex
      hyperfine
      lazysql
      procs
      sd
      tokei
      trash-cli
      wget
    ];

    programs = {
      bottom.enable = true;
      eza.enable = true;
      fastfetch.enable = true;
      fd.enable = true;
      jq.enable = true;
      ripgrep.enable = true;
      yazi.enable = true;
    };
  };
}
