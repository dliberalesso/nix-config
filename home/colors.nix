{ config, lib, ... }:

{
  options = with lib; with types; {
    colors = mkOption { type = attrs; };
  };

  # Dracula PRO - Van Helsing
  config.colors = {
    foreground = "#f8f8f2";
    background = "#0b0d0f";
    selection = "#414d58";
    comment = "#708ca9";
    red = "#ff9580";
    orange = "#ffca80";
    yellow = "#ffff80";
    green = "#8aff80";
    purple = "#9580ff";
    cyan = "#80ffea";
    pink = "#ff80bf";
  };
}
