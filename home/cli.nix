{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fd
    grex
    hyperfine
    sd
    tokei
    wget
  ];

  programs = {
    bottom.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;

    bat = {
      enable = true;

      config = {
        color = "always";
        pager = "less";
      };
    };

    eza.enable = true;
    fish.shellAliases = rec {
      ls = "${pkgs.eza}/bin/eza --icons";
      ll = "${ls} -l";
      la = "${ls} -a";
      lt = "${ls} --tree";
      lla = "${ls} -la";
    };

    fzf = rec {
      enable = true;

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

      historyWidgetOptions = [];
    };
  };

  home.activation.tealdeer =
    lib.hm.dag.entryAfter [
      "linkGeneration"
      "writeBoundary"
    ] ''
      $DRY_RUN_CMD ${pkgs.tealdeer}/bin/tldr --update $VERBOSE_ARG
    '';
}
