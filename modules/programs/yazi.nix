{
  unify.home =
    {
      pkgs,
      ...
    }:
    {
      programs.yazi = {
        enable = true;

        initLua = /* lua */ ''
          require("git"):setup {
            order = 1500,
          }

          require("starship"):setup()

          if os.getenv("NVIM") then
            require("toggle-pane"):entry("min-preview")
          end
        '';

        keymap = {
          mgr.prepend_keymap = [
            {
              on = "C";
              run = "plugin ouch";
              desc = "Compress with ouch";
            }
            {
              on = [
                "g"
                "i"
              ];
              run = "plugin lazygit";
              desc = "run lazygit";
            }
            {
              on = [
                "g"
                "j"
              ];
              run = "plugin jjui";
              desc = "run jjui";
            }
            {
              on = "T";
              run = "plugin toggle-pane max-preview";
              desc = "Maximize or restore the preview pane";
            }

          ];
        };

        plugins = {
          inherit (pkgs.yaziPlugins)
            jjui
            lazygit
            git
            ouch
            piper
            starship
            toggle-pane
            ;
        };

        settings = {
          plugin.prepend_fetchers = [
            {
              id = "git";
              url = "*";
              run = "git";
              group = "git";
            }
            {
              id = "git";
              url = "*/";
              run = "git";
              group = "git";
            }
          ];

          plugin.prepend_previewers = [
            {
              mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
              run = "ouch";
            }
          ];
        };
      };
    };
}
