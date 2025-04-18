{
  pkgs,
  ...
}:
{
  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Configure custom keymaps
  services.xserver.xkb = {
    layout = "us-esc";

    extraLayouts = {
      br-esc = {
        description = "BR with ESC instead of CAPS";
        languages = [ "por" ];
        symbolsFile = pkgs.writeText "br-esc" ''
          default partial alphanumeric_keys

          xkb_symbols "br-esc" {
            include "br(abnt2)"
            name[Group1]= "BR with ESC instead of CAPS";

            key <CAPS> { [ Escape ] };
          };
        '';
      };

      us-esc = {
        description = "US-INTL with ESC instead of CAPS";
        languages = [ "eng" ];
        symbolsFile = pkgs.writeText "us-esc" ''
          default partial alphanumeric_keys

          xkb_symbols "us-esc" {
            include "us(intl)"
            name[Group1]= "US-INTL with ESC instead of CAPS";

            key <ESC> { [ dead_grave, dead_tilde, grave, asciitilde ] };
            key <CAPS> { [ Escape ] };
          };
        '';
      };
    };
  };
}
