{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    grex
    hyperfine
    manix
    sd
    tokei
    wget
  ];

  programs = {
    bottom.enable = true;
    eza.enable = true;
    fd.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
    yazi.enable = true;

    bat = {
      enable = true;

      config = {
        color = "always";
        pager = "less";
      };
    };

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

  home.activation.tealdeer =
    lib.hm.dag.entryAfter
      [
        "linkGeneration"
        "writeBoundary"
      ]
      ''
        $DRY_RUN_CMD ${pkgs.tealdeer}/bin/tldr --update $VERBOSE_ARG
      '';
}
