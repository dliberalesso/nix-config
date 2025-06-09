{
  hm,
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
    programs.lazygit = {
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
  }
)
