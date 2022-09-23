{ lib, ... }:

with lib; with types;

{
  options.theme = {
    variant = mkOption {
      type = enum [
        "dracula_pro_base"
        "dracula_pro_blade"
        "dracula_pro_buffy"
        "dracula_pro_lincoln"
        "dracula_pro_morbius"
        "dracula_pro_van_helsing"
      ];
      default = "dracula_pro_base";
    };

    colors = mkOption {
      type = attrs;
      internal = true;
    };
  };
}
