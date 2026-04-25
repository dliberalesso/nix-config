{
  unify.home =
    {
      hostConfig,
      lib,
      pkgs,
      ...
    }:
    let
      jj-lazymoji =
        name: command:
        pkgs.writeShellApplication {
          name = "jj-lazymoji-${name}";

          runtimeInputs = [ pkgs.lazymoji ];

          text = ''
            jj ${command} -m "$(lazymoji)"
          '';
        };

      jj-pre-commit = pkgs.writeShellApplication {
        name = "jj-pre-commit";

        text = ''
          if [ "$(jj log --no-graph -r @ -T 'empty')" = "false" ]; then
            jj new
          fi

          FROM=$(jj log --no-graph -r "fork_point(trunk() | @)" -T "commit_id")

          TO=$(jj log --no-graph -r "@" -T "commit_id")

          pre-commit run --from="$FROM" --to="$TO" "$@"
        '';
      };

      jj-squash-and-pre-commit = pkgs.writeShellApplication {
        name = "jj-squash-and-pre-commit";

        text = ''
          jj squash

          ${lib.getExe jj-pre-commit}
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
      home.packages = with pkgs; [
        jjui
        watchman
      ];

      programs.jujutsu = {
        enable = true;

        settings = {
          aliases = {
            cm = utilExecFor (jj-lazymoji "cm" "commit");

            dm = utilExecFor (jj-lazymoji "dm" "describe");

            "dm-" = utilExecFor (jj-lazymoji "dmm" "describe -r @-");

            pre-commit = utilExecFor jj-pre-commit;

            sq = utilExecFor jj-squash-and-pre-commit;

            tug = [
              "bookmark"
              "move"
              "--from"
              "closest_bookmark(@)"
              "--to"
              "closest_pushable(@)"
            ];
          };

          fsmonitor = {
            backend = "watchman";
            watchman.register-snapshot-trigger = true;
          };

          git = {
            private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
            fetch = [ "origin" ];
            sign-on-push = true;
            write-change-id-header = true;
          };

          merge-tools = {
            delta = {
              diff-expected-exit-codes = [
                0
                1
              ];
              program = "delta";
              diff-args = [
                "--file-transformation"
                "s:tmp/jj-diff.*/(left|right)::"
                "$left"
                "$right"
              ];
            };

            diffconflicts = {
              program = "nvim";
              merge-args = [
                "-c"
                "let g:jj_diffconflicts_marker_length=$marker_length"
                "-c"
                "JJDiffConflicts!"
                "$output"
                "$base"
                "$left"
                "$right"
              ];
              merge-tool-edits-conflict-markers = true;
            };
          };

          remotes = {
            origin = {
              auto-track-bookmarks = "glob:*";
            };
          };

          revset-aliases = {
            "closest_bookmark(to)" = "heads(::to & bookmarks())";
            "closest_pushable(to)" =
              "heads(::to & mutable() & ~description(exact:\"\") & (~empty() | merges()))";
          };

          signing = {
            behavior = "keep";
            backend = "gpg";
            key = "EABBB5191B42D726";
          };

          snapshot.max-new-file-size = "15M";

          ui = {
            default-command = "log";
            diff-editor = [
              "nvim"
              "-c"
              "DiffEditor $left $right $output"
            ];
            diff-formatter = "delta";
            graph.style = "square";
            merge-editor = "diffconflicts";
            pager = "delta";
            show-cryptographic-signatures = true;
          };

          user = { inherit (hostConfig.user) email name; };
        };
      };
    };
}
