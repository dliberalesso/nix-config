{
  hm,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.nix-index-database.nixosModules.nix-index ];

  programs.bandwhich.enable = true;
}
// hm {
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

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

    eza = {
      enable = true;
      colors = "auto";
      icons = "auto";
    };

    fastfetch.enable = true;
    fd.enable = true;
    jq.enable = true;
    nix-index-database.comma.enable = true;
    nix-index.enable = true;
    ripgrep.enable = true;
    yazi.enable = true;
  };
}
