{
  hm,
  user,
  ...
}:
let
  aliases = {
    pre-commit = [
      "util"
      "exec"
      "--"
      "bash"
      "-c"
      # bash
      ''
        set -euo pipefail
        EMPTY=$(jj log --no-graph -r @ -T 'empty')
        if [ "$EMPTY" = "false" ]; then
          jj new
        fi
        FROM=$(jj log --no-graph -r "fork_point(trunk() | @)" -T "commit_id")
        TO=$(jj log --no-graph -r "@" -T "commit_id")
        pre-commit run --from="$FROM" --to="$TO" "$@"
      ''
    ];

    tug = [
      "bookmark"
      "move"
      "--from"
      "closest_bookmark(@)"
      "--to"
      "closest_pushable(@)"
    ];

    l = [
      "log"
      "-r"
      "all()"
    ];

    ll = [
      "log"
      "-r"
      "all()"
      "-T"
      "builtin_log_detailed"
    ];

    xl = [
      "log"
      "-T"
      "builtin_log_detailed"
    ];

    open = [
      "log"
      "-r"
      "open()"
    ];

    stack = [
      "log"
      "-r"
      "stack()"
    ];

    s = [ "stack" ];

    evolve = [
      "rebase"
      "--skip-empty"
      "-d"
      "main"
    ];

    yank = [
      "rebase"
      "--skip-emptied"
      "-s"
      "all:roots(mutable() & mine())"
      "-d"
      "trunk()"
    ];
  };
in
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
        inherit aliases;

        core = {
          fsmonitor = "watchman";
          watchman.register-snapshot-trigger = true;
        };

        git = {
          private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
          auto-local-bookmark = true;
          fetch = [ "origin" ];
          write-change-id-header = true;
        };

        ui = {
          default-command = "l";
          diff-editor = ":builtin";
          graph.style = "square";
          pager = ":builtin";
          show-cryptographic-signatures = true;
        };

        user = { inherit (user) email name; };

        snapshot.max-new-file-size = "15M";
      };
    };
  }
)
