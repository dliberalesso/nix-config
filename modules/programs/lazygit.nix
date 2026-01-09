{
  unify.home =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.lazygit = {
        enable = true;

        settings = {
          customCommands = [
            {
              key = "C";
              description = "Use lazymoji";
              context = "files";
              command = "${lib.getExe pkgs.lazymoji} -l";
              output = "terminal";
            }
          ];

          git = {
            pagers = [
              (lib.optionalAttrs config.programs.delta.enableGitIntegration {
                pager = "${lib.getExe pkgs.delta} --dark --paging=never";
              })
            ];

            parseEmoji = true;
          };

          os.editPreset = "nvim-remote";

          update.method = "never";
        };
      };
    };
}
