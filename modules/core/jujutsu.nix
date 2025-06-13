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
    home.packages = builtins.attrValues {
      inherit (pkgs) jjui lazymoji;
    };

    programs.jujutsu = {
      enable = true;

      settings = {
        core = {
          fsmonitor = "watchman";
          watchman.register-snapshot-trigger = true;
        };

        snapshot.max-new-file-size = "15M";

        user = { inherit (user) email name; };

        ui = {
          default-command = "l";
          diff-editor = ":builtin";
          graph.style = "square";
          pager = ":builtin";
          show-cryptographic-signatures = true;
        };

        git = {
          private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
          auto-local-bookmark = true;
          fetch = [
            "origin"
          ];
          write-change-id-header = true;
        };
      };
    };
  }
)
