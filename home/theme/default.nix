{ lib, ... }:

# Let"s theme the **** out of this!

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

    colors = rec {
      fg = "#F8F8F2";

      bglighter = "#393649";
      bglight = "#2E2B3B";
      bg = "#22212C";
      bgdark = "#17161D";
      bgdarker = "#0B0B0F";

      comment = "#7970A9";
      selection = "#454158";
      subtle = "#424450";

      cyan = "#80FFEA";
      green = "#8AFF80";
      orange = "#FFCA80";
      pink = "#FF80BF";
      purple = "#9580FF";
      red = "#FF9580";
      yellow = "#FFFF80";

      color_0 = selection;
      color_1 = red;
      color_2 = green;
      color_3 = yellow;
      color_4 = purple;
      color_5 = pink;
      color_6 = cyan;
      color_7 = fg;
      color_8 = comment;
      color_9 = "#FFAA99";
      color_10 = "#A2FF99";
      color_11 = "#FFFF99";
      color_12 = "#AA99FF";
      color_13 = "#FF99CC";
      color_14 = "#99FFEE";
      color_15 = "#FFFFFF";
    };

    tmTheme = ./alucard.tmTheme;
  };
}
