{
  config,
  ...
}:
{
  security.pam.services.hyprlock = { };

  home-manager.users.dli50 = {
    catppuccin.hyprlock.enable = false;

    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          disable_loading_bar = false;
          grace = 1;
          hide_cursor = true;
          no_fade_in = false;
          ignore_empty_input = true;
          text_trim = true;
        };

        background = {
          path = "${config.hyprde.wallpaper}";
          blur_passes = 3;
          blur_size = 8;
        };

        label = [
          # TIME Hours
          {
            text = "cmd[update:1000] date +'%H'";
            color = "rgba(255, 255, 255, 1)";
            shadow_pass = 2;
            shadow_size = 3;
            shadow_color = "rgb(0,0,0)";
            shadow_boost = 1.2;
            font_size = 150;
            position = "0, -250";
            halign = "center";
            valign = "top";
          }
          # TIME Minutes
          {
            text = "cmd[update:1000] date +'%M'";
            color = "rgba(255, 255, 255, 1)";
            font_size = 150;
            position = "0, -420";
            halign = "center";
            valign = "top";
          }
          # DATE
          {
            text = "cmd[update:1000] date '+%a, %d de %B de %Y'";
            color = "rgba(255, 255, 255, 1)";
            font_size = 17;
            position = "0, -130";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = {
          size = "250, 60";
          outline_thickness = 0;
          outer_color = "rgba(0, 0, 0, 0)";
          dots_size = 0.1;
          dots_spacing = 1;
          dots_center = true;
          inner_color = "rgba(0, 0, 0, 0)";
          font_color = "rgba(200, 200, 200, 1)";
          fade_on_empty = false;
          placeholder_text = "<span> $USER</span>";
          hide_input = false;
          position = "0, -470";
          halign = "center";
          valign = "center";
          zindex = 10;
        };
      };
    };
  };
}
