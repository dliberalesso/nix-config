{
  unify.modules.hyprde.home = {
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          # avoid starting multiple hyprlock instances.
          lock_cmd = "pidof hyprlock || hyprlock";
          # lock before suspend.
          before_sleep_cmd = "loginctl lock-session";
          # to avoid having to press a key twice to turn on the display.
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = true;
        };

        listener = [
          {
            # dimm lights after 2min
            timeout = 120;
            on-timeout = "brightnessctl -s set 10 && brightnessctl -sd rgb:kbd_backlight set 0";
            on-resume = "brightnessctl -r && brightnessctl -sd rgb:kbd_backlight set 0";
          }
          {
            # lock the screen after 3min
            timeout = 180;
            on-timeout = "loginctl lock-session";
          }
          {
            # turn off the screen after 4min
            timeout = 240;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
          }
        ];
      };
    };
  };
}
