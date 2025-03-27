{
  pkgs,
  inputs,
  ...
}:
let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.system};
in
{
  imports = [ inputs.spicetify.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;

    enabledExtensions = with spicePkgs.extensions; [
      playlistIcons
      historyShortcut
      adblock
      fullAppDisplay
      keyboardShortcut
    ];

    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };
}
