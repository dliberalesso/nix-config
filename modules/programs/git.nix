{
  unify.home =
    {
      hostConfig,
      lib,
      pkgs,
      ...
    }:
    {
      programs = {
        delta = {
          enable = true;
          enableGitIntegration = true;
        };

        gh.enable = true;

        gh-dash.enable = true;

        git = {
          enable = true;

          ignores = [
            ".direnv"
            "result"
          ];

          lfs.enable = true;

          settings = {
            credential.helper = "${
              pkgs.git.override {
                withLibsecret = true;
              }
            }/bin/git-credential-libsecret";

            init.defaultBranch = "main";
            push.autoSetupRemote = true;
            url."https://github.com/".insteadOf = "git://github.com/";

            user = { inherit (hostConfig.user) email name; };
          };

          signing = {
            inherit (hostConfig) allowedSigners;
          }
          // lib.optionalAttrs (hostConfig.signingKey != null) {
            format = "ssh";
            key = "key::${hostConfig.signingKey}";
            signByDefault = true;
          };
        };
      };
    };
}
