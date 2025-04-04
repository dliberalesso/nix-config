{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixos.fonts;
in
{
  options.nixos.fonts = {
    enable = lib.mkEnableOption "Enable fonts config";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      fira-code
      fira-code-symbols
      font-awesome
      material-icons
      monaspace
      noto-fonts-emoji
      noto-fonts-cjk-sans
      symbola
    ];
  };
}
