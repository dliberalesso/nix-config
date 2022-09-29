{ lib, ... }:

# Let's theme the **** out of this!

{
  imports = [
    ./dracula.nix
    # ./dracula_pro.nix
  ];

  options.theme = with lib; {
    name = mkOption {
      type = types.str;
      readOnly = true;
    };

    colors = mkOption {
      type = types.attrs;
      readOnly = true;
    };
  };
}
