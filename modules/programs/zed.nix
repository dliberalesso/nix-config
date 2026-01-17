{
  unify.home =
    {
      lib,
      pkgs,
      ...
    }:
    {
      programs.zed-editor = {
        enable = true;

        installRemoteServer = true;

        extensions = [
          "catppuccin-icons"
          "nix"
        ];

        userSettings = {
          auto_update = false;

          hour_format = "hour24";

          load_direnv = "shell_hook";

          lsp = {
            nix.binary.path_lookup = true;
          };

          node = {
            path = lib.getExe pkgs.nodejs;
            npm_path = lib.getExe' pkgs.nodejs "npm";
          };

          theme = {
            mode = "dark";
            dark = "Catppuccin Mocha";
          };

          vim_mode = true;
        };
      };
    };
}
