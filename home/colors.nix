{ config, lib, ... }:

{
  options = with lib; with types; {
    colors = mkOption { type = attrs; };
  };

  # Dracula PRO
  config.colors = {
    foreground = "#f8f8f2";
    red = "#ff9580";
    orange = "#ffca80";
    yellow = "#ffff80";
    green = "#8aff80";
    purple = "#9580ff";
    cyan = "#80ffea";
    pink = "#ff80bf";

    # Base
    background = "#22212C";
    comment = "#7970A9";
    selection = "#454158";

    # Van Helsing
    # background = "#0b0d0f";
    # comment = "#708ca9";
    # selection = "#414d58";
  };
}
