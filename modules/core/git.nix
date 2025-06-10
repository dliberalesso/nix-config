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
          customCommands = [
            {
              key = "C";
              description = "conventional commit";
              context = "files";
              prompts = [
                {
                  type = "menu";
                  title = "Select the type of change you are committing.";
                  key = "Type";
                  options = [
                    {
                      name = "Feature";
                      description = "a new feature";
                      value = "feat";
                    }
                    {
                      name = "Fix";
                      description = "a bug fix";
                      value = "fix";
                    }
                    {
                      name = "Documentation";
                      description = "Documentation only changes";
                      value = "docs";
                    }
                    {
                      name = "Styles";
                      description = "Styling changes (white-space, formatting, etc)";
                      value = "style";
                    }
                    {
                      name = "Code Refactoring";
                      description = "Refactoring code";
                      value = "refactor";
                    }
                    {
                      name = "Performance Improvements";
                      description = "Performance improvements";
                      value = "perf";
                    }
                    {
                      name = "Tests";
                      description = "Test additions or fixes";
                      value = "test";
                    }
                    {
                      name = "Builds";
                      description = "Build system or dependency changes";
                      value = "build";
                    }
                    {
                      name = "Continuous Integration";
                      description = "CI configuration changes";
                      value = "ci";
                    }
                    {
                      name = "Chores";
                      description = "Other non-code changes";
                      value = "chore";
                    }
                    {
                      name = "Reverts";
                      description = "Reverting changes";
                      value = "revert";
                    }
                  ];
                }
              ];
              command = "echo '{{ .Form.Type }}: ' > .git/LAZYGIT_PENDING_COMMIT";
            }
          ];

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
