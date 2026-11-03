{
  unify.home =
    {
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
            "conda"
            "crystal"
            "dart"
            "deno"
            "docker_context"
            "elm"
            "fennel"
            "fossil_branch"
            "gcloud"
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
        enableZshIntegration = true;

        settings = lib.mkMerge [
          (lib.importTOML preset)
          disabledModules
          {
            format = lib.concatStrings [
              "$username"
              "$hostname"
              "$localip"
              "$directory"
              "$git_branch"
              "$git_commit"
              "$git_state"
              "$git_metrics"
              "$git_status"
              "$all"
            ];

            nix_shell.format = "via [$symbol($name)]($style) ";
          }
        ];
      };
    };
}
