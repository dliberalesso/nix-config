{
  moduleWithSystem,
  ...
}:
{
  perSystem.wrappers.fzf =
    {
      inputs',
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        getExe
        importJSON
        mapAttrsToList
        pipe
        ;

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

      renderedColors = pipe inputs'.catppuccin.packages.palette [
        (s: (importJSON "${s}/palette.json").mocha.colors)
        (p: builtins.mapAttrs (_: c: p.${c}.hex) scheme)
        (c: mapAttrsToList (n: v: "${n}:${v}") c)
        (l: builtins.concatStringsSep "," l)
      ];
    in
    {
      basePackage = pkgs.fzf;

      env = {
        FZF_ALT_C_COMMAND.value = "${getExe pkgs.fd} --type d";
        FZF_ALT_C_OPTS.value = "--preview '${getExe pkgs.eza} --tree --icons | head -200'";
        FZF_CTRL_T_COMMAND.value = "${getExe pkgs.fd} --type f";
        FZF_CTRL_T_OPTS.value = "--preview '${getExe pkgs.bat} --plain --line-range=:200 {}'";
        FZF_DEFAULT_COMMAND.value = "${getExe pkgs.fd} --type f";
        FZF_DEFAULT_OPTS.value = "--height 50% --color ${renderedColors}";
      };

      postBuild = ''
        rm -rf $out/share/{nvim,vim-plugins}
      '';
    };

  unify.home = moduleWithSystem (
    { config }:
    {
      lib,
      ...
    }:
    let
      inherit (config.wrappers) fzf;

      inherit (lib) getExe;
    in
    {
      home.packages = [ fzf.wrapped ];

      home.sessionVariables = builtins.mapAttrs (_: v: v.value) fzf.env;

      programs.fish.interactiveShellInit = lib.mkOrder 200 ''
        ${getExe fzf.wrapped} --fish | source
      '';
    }
  );
}
