{ lib, ... }:

# Let's theme the **** out of this!

{
  options.theme = with lib; with types; {
    name = mkOption {
      type = str;
      readOnly = true;
    };

    colors = mkOption {
      type = attrs;
      readOnly = true;
    };

    tmTheme = mkOption {
      type = path;
      readOnly = true;
    };
  };

  config.theme = {
    name = "alucard";

    colors = {
      background = "#22212C";
      selection = "#454158";
      foreground = "#F8F8F2";
      comment = "#7970A9";
      cyan = "#80FFEA";
      green = "#8AFF80";
      orange = "#FFCA80";
      pink = "#FF80BF";
      purple = "#9580FF";
      red = "#FF9580";
      yellow = "#FFFF80";
    };

    tmTheme = ./alucard.tmTheme;
  };
}
