{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    dust
    grex
    hyperfine
    lazysql
    procs
    sd
    tokei
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

    fzf = rec {
      enable = true;

      package = pkgs.fzf.overrideAttrs (oa: {
        postInstall =
          oa.postInstall
          + ''
            rm -rf $out/share/nvim/
          '';
      });

      defaultCommand = "fd --type f";
      defaultOptions = [
        "--height 50%"
      ];

      fileWidgetCommand = "${defaultCommand}";
      fileWidgetOptions = [
        "--preview 'bat --plain --line-range=:200 {}'"
      ];

      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [
        "--preview 'eza --tree --icons | head -200'"
      ];

      historyWidgetOptions = [ ];
    };
  };
}
