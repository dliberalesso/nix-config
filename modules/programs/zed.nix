{
  inputs,
  ...
}:
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
          "nix"
        ];

        userSettings = {
          auto_update = false;

          buffer_font_family = "Monaspace Neon NF";
          buffer_font_size = 15;

          languages = {
            Nix.language_servers = [
              "!nil"
              "nixd"
            ];
          };

          load_direnv = "shell_hook";

          lsp = {
            nixd = {
              binary.path = lib.getExe pkgs.nixd;

              settings = {
                formatting.command = [
                  (lib.getExe pkgs.nixfmt)
                ];

                nixpkgs.expr = ''
                  import "${pkgs.path}" {};
                '';

                options = {
                  nixos.expr = ''
                    ((import "${pkgs.path}" {}).lib.evalModules {
                      modules = (import "${pkgs.path}/nixos/modules/module-list.nix");
                      check = false; }
                    ).options
                  '';

                  home-manager.expr = ''
                    (let
                      pkgs = import "${pkgs.path}" {};
                      lib = import "${inputs.home-manager}/modules/lib/stdlib-extended.nix" pkgs.lib;
                    in (
                      lib.evalModules {
                        modules = (import "${inputs.home-manager}/modules/modules.nix") {
                          inherit lib pkgs;
                          check = false;
                        };
                      })
                    ).options
                  '';
                };
              };
            };
          };

          node = {
            path = lib.getExe pkgs.nodejs;
            npm_path = lib.getExe' pkgs.nodejs "npm";
          };

          terminal.font_family = "Monaspace Neon NF";

          theme.mode = "dark";
        };
      };
    };
}
