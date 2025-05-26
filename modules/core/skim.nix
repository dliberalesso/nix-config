{
  config,
  hm,
  lib,
  ...
}:
let
  enabled = config.programs.skim.enable;

  mkEnableOption = name: {
    ${name}.enable = lib.mkEnableOption name;
  };
in
{
  disabledModules = [ "programs/skim.nix" ];

  options.programs = mkEnableOption "skim";

  config = lib.mkIf enabled (hm {
    programs.skim = rec {
      enable = true;

      defaultCommand = "fd --type f";
      defaultOptions = [ "--height 50%" ];

      fileWidgetCommand = defaultCommand;
      fileWidgetOptions = [
        "--preview 'bat --plain --line-range=:200 {}'"
      ];

      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [
        "--preview 'eza --tree --icons | head -200'"
      ];
    };
  });
}
