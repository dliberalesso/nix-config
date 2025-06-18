{
  unify.home =
    {
      hostConfig,
      lib,
      pkgs,
      ...
    }:
    let
      jj-pre-commit = pkgs.writeShellApplication {
        name = "jj-pre-commit";

        text = ''
          set -euo pipefail

          if [ "$(jj log --no-graph -r @ -T 'empty')" = "false" ]; then
            jj new
          fi

          FROM=$(jj log --no-graph -r "fork_point(trunk() | @)" -T "commit_id")

          TO=$(jj log --no-graph -r "@" -T "commit_id")

          pre-commit run --from="$FROM" --to="$TO" "$@"
        '';
      };

      jj-lazymoji =
        name: command:
        pkgs.writeShellApplication {
          name = "jj-lazymoji-${name}";

          runtimeInputs = [ pkgs.lazymoji ];

          text = ''
            set -euo pipefail

            jj ${command} -m "$(lazymoji)"
          '';
        };

      utilExecFor = script: [
        "util"
        "exec"
        "--"
        "${lib.getExe script}"
      ];
    in
    {
      home.packages = [ pkgs.jjui ];

      programs.jujutsu = {
        enable = true;

        package = pkgs.jujutsu.overrideAttrs (oa: {
          buildInputs = oa.buildInputs ++ [ pkgs.watchman ];
        });

        settings = {
          aliases = {
            cm = utilExecFor (jj-lazymoji "cm" "commit");

            dm = utilExecFor (jj-lazymoji "dm" "describe");

            "dm-" = utilExecFor (jj-lazymoji "dmm" "describe -r @-");

            pre-commit = utilExecFor jj-pre-commit;

            tug = [
              "bookmark"
              "move"
              "--from"
              "closest_bookmark(@)"
              "--to"
              "closest_pushable(@)"
            ];
          };

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

          revset-aliases = {
            "closest_bookmark(to)" = "heads(::to & bookmarks())";
            "closest_pushable(to)" =
              "heads(::to & mutable() & ~description(exact:\"\") & (~empty() | merges()))";
          };

          ui = {
            default-command = "log";
            diff-editor = ":builtin";
            graph.style = "square";
            pager = ":builtin";
            show-cryptographic-signatures = true;
          };

          user = { inherit (hostConfig.user) email name; };

          snapshot.max-new-file-size = "15M";
        };
      };
    };
}
