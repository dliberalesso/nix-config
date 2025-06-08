{
  hm,
  user,
  ...
}:
hm (
  {
    config,
    lib,
    pkgs,
    ...
  }:
  {
    home.packages = [ pkgs.koji ];
    programs = {
      gh.enable = true;

      git = {
        enable = true;

        delta.enable = true;

        extraConfig = {
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
          url."https://github.com/".insteadOf = "git://github.com/";
        };

        ignores = [
          ".direnv"
          "result"
        ];

        lfs.enable = true;

        userName = user.name;
        userEmail = user.email;
      };

      lazygit = {
        enable = true;

        settings = {
          git.paging =
            {
              colorArg = "always";
            }
            // lib.optionalAttrs config.programs.git.delta.enable {
              pager = "${lib.getExe pkgs.delta} --dark --paging=never";
            };

          os.editPreset = "nvim-remote";

          update.method = "never";
        };
      };
    };
  }
)
