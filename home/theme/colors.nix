{ config, lib, ... }:

let
  variants = {
    dracula_pro_base = {
      background = "#22212C";
      comment = "#7970A9";
      selection = "#454158";
    };

    dracula_pro_blade = {
      background = "#212C2A";
      comment = "#70A99F";
      selection = "#415854";
    };

    dracula_pro_buffy = {
      background = "#2A212C";
      comment = "#9F70A9";
      selection = "#544158";
    };

    dracula_pro_lincoln = {
      background = "#2C2A21";
      comment = "#A99F70";
      selection = "#585441";
    };

    dracula_pro_morbius = {
      background = "#2C2122";
      comment = "#A97079";
      selection = "#584145";
    };

    dracula_pro_van_helsing = {
      background = "#0B0D0F";
      comment = "#708CA9";
      selection = "#414D58";
    };
  };

  variant = config.theme.variant;

  standard = {
    foreground = "#F8F8F2";
    cyan = "#80FFEA";
    green = "#8AFF80";
    orange = "#FFCA80";
    pink = "#FF80BF";
    purple = "#9580FF";
    red = "#FF9580";
    yellow = "#FFFF80";
    background = variants.${variant}.background;
    comment = variants.${variant}.comment;
    selection = variants.${variant}.selection;
  };
in

{
  config.theme.colors = lib.mkMerge [ standard variants ];
}
