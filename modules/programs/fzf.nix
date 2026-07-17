{
  perSystem =
    {
      pkgs,
      ...
    }:
    let
      fzf = pkgs.fzf.overrideAttrs (oa: {
        postInstall = ''
          ${oa.postInstall or ""}
          rm -rf $out/share/{nvim,vim-plugins}
        '';
      });
    in
    {
      overlayAttrs = { inherit fzf; };

      packages = { inherit fzf; };
    };

  unify.home =
    {
      lib,
      pkgs,
      ...
    }:
    let
      bat = lib.getExe pkgs.bat;
      eza = lib.getExe pkgs.eza;
      fd = lib.getExe pkgs.fd;

      defaultCommand = "${fd} --type f";
    in
    {
      programs.fzf = {
        enable = true;

        inherit defaultCommand;
        defaultOptions = [ "--height 50%" ];

        fileWidget = {
          command = defaultCommand;
          options = [
            "--preview '${bat} --plain --line-range=:200 {}'"
          ];
        };

        changeDirWidget = {
          command = "${fd} --type d";
          options = [
            "--preview '${eza} --tree --icons | head -200'"
          ];
        };

        historyWidget.command = "";
      };
    };
}
