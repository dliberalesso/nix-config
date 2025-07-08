{
  moduleWithSystem,
  ...
}:
{
  perSystem.wrapper-manager.fzf =
    {
      pkgs,
      ...
    }:
    {
      basePackage = pkgs.fzf;

      postBuild = ''
        rm -rf $out/share/{nvim,vim-plugins}
      '';
    };

  # TODO: Remove this when wrapping the shell
  unify.home = moduleWithSystem (
    { config, inputs' }:
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.wrapper-manager) fzf;

      inherit (inputs'.catppuccin.packages) palette;

      inherit (lib) getExe importJSON mapAttrsToList;

      # TODO: Colorscheme // catppuccin mocha mauve.
      scheme = {
        "bg+" = "surface0";
        bg = "base";
        spinner = "rosewater";
        hl = "mauve";
        fg = "text";
        header = "mauve";
        info = "mauve";
        pointer = "mauve";
        marker = "mauve";
        "fg+" = "text";
        prompt = "mauve";
        "hl+" = "mauve";
      };

      renderedColors =
        (importJSON "${palette}/palette.json").mocha.colors
        |> (p: builtins.mapAttrs (_: c: p.${c}.hex) scheme)
        |> (c: mapAttrsToList (n: v: "${n}:${v}") c)
        |> (l: builtins.concatStringsSep "," l);
    in
    {
      home.packages = [ fzf ];

      home.sessionVariables = {
        FZF_ALT_C_COMMAND = "${getExe pkgs.fd} --type d";
        FZF_ALT_C_OPTS = "--preview '${getExe pkgs.eza} --tree --icons | head -200'";
        FZF_CTRL_T_COMMAND = "${getExe pkgs.fd} --type f";
        FZF_CTRL_T_OPTS = "--preview '${getExe pkgs.bat} --plain --line-range=:200 {}'";
        FZF_DEFAULT_COMMAND = "${getExe pkgs.fd} --type f";
        FZF_DEFAULT_OPTS = "--height 50% --color ${renderedColors}";
      };

      programs.fish.interactiveShellInit = lib.mkOrder 200 ''
        ${getExe fzf} --fish | source
      '';
    }
  );
}
