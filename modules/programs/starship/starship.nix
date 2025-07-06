{
  unify.home =
    {
      hostConfig,
      lib,
      pkgs,
      ...
    }:
    let
      presetName = "nerd-font-symbols";

      preset = "${pkgs.starship}/share/starship/presets/${presetName}.toml";

      disabledModules =
        lib.genAttrs
          [
            "aws"
            "buf"
            "bun"
            "conda"
            "crystal"
            "dart"
            "deno"
            "docker_context"
            "elm"
            "fennel"
            "fossil_branch"
            "gcloud"
            "git_branch"
            "git_commit"
            "git_state"
            "git_metrics"
            "git_status"
            "gradle"
            "guix_shell"
            "haskell"
            "haxe"
            "hg_branch"
            "java"
            "julia"
            "kotlin"
            "memory_usage"
            "nim"
            "perl"
            "ocaml"
            "pijul_channel"
            "pixi"
            "rlang"
            "ruby"
            "scala"
            "swift"
            "zig"
          ]
          (_key: {
            disabled = true;
          });
    in
    {
      programs.starship = {
        enable = true;

        settings = lib.mkMerge [
          (lib.importTOML preset)
          disabledModules
          {
            format = lib.concatStrings [
              "$username"
              "$hostname"
              "$localip"
              "$directory"
              "\${custom.vcs}"
              "$all"
            ];

            custom.vcs = {
              command = "all";
              detect_folders = [
                ".git"
                ".jj"
              ];
              format = "($output )";
              ignore_timeout = true;
              require_repo = true;
              shell = [
                "${hostConfig.flakePath}/modules/programs/starship/custom-vcs.sh"
              ];
              use_stdin = false;
              when = true;
            };

            nix_shell.format = "via [$symbol($name)]($style) ";
          }
        ];
      };
    };
}
