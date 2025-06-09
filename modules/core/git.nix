{
  hm,
  user,
  ...
}:
hm (
  {
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

      jujutsu.enable = true;
    };
  }
)
