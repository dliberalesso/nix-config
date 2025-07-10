{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      overlayAttrs = {
        jujutsu = pkgs.jujutsu.overrideAttrs (oa: {
          nativeBuildInputs = (oa.nativeBuildInputs or [ ]) ++ [
            pkgs.makeBinaryWrapper
          ];

          postFixup = ''
            ${oa.postFixup or ""}
            wrapProgram $out/bin/jj \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.watchman ]}
          '';
        });
      };
    };

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
      home.packages = [ pkgs.jjui ];

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

          merge-tools = {
            delta = {
              diff-expected-exit-codes = [
                0
                1
              ];
              program = lib.getExe pkgs.delta;
              merge-args = [
                "--diff-so-fancy"
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

          ui = {
            default-command = "log";
            diff-editor = [
              "nvim"
              "-c"
              "DiffEditor $left $right $output"
            ];
            diff-formatter = "delta";
            diff-tool = "delta";
            graph.style = "square";
            merge-editor = "diffconflicts";
            pager = "delta";
            show-cryptographic-signatures = true;
          };

          user = { inherit (hostConfig.user) email name; };

          snapshot.max-new-file-size = "15M";
        };
      };
    };
}
