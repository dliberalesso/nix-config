{
  unify.nixos.nixpkgs.overlays = [
    (_: prev: {
      fzf = prev.fzf.overrideAttrs (oa: {
        postInstall = ''
          ${oa.postInstall or ""}
          rm -rf $out/share/nvim/
        '';
      });
    })
  ];

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

        fileWidgetCommand = defaultCommand;
        fileWidgetOptions = [
          "--preview '${bat} --plain --line-range=:200 {}'"
        ];

        changeDirWidgetCommand = "${fd} --type d";
        changeDirWidgetOptions = [
          "--preview '${eza} --tree --icons | head -200'"
        ];
      };
    };
}
