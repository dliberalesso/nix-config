{
  inputs,
  lib,
  ...
}:
let
  assertPresent = lib.asserts.assertMsg (
    inputs.spicetify ? legacyPackages
  ) "inputs.spicetify doesn't provide legacyPackages";
in
lib.optionalAttrs assertPresent {
  unify.modules.gui.home =
    {
      pkgs,
      ...
    }:
    let
      inherit (inputs.spicetify) legacyPackages homeManagerModules;

      spicePkgs = legacyPackages.${pkgs.system};
    in
    {
      imports = [ homeManagerModules.default ];

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
    };
}
