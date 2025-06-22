{
  unify.modules.hyprde = {
    nixos.programs.hyprland = {
      enable = true;
      withUWSM = true;
      # xwayland.enable = false;
    };

    home =
      {
        lib,
        pkgs,
        ...
      }:
      {
        wayland.windowManager.hyprland = {
          enable = true;

          extraConfig = builtins.readFile ./hyprland.conf;

          settings =
            let
              env = [
                "LIBVA_DRIVER_NAME, nvidia"
                "__GLX_VENDOR_LIBRARY_NAME, nvidia"
                "NVD_BACKEND, direct"
              ];
            in
            {
              inherit env;

              "$mainMod" = "SUPER";

              # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
              dwindle = {
                # Master switch for pseudotiling.
                pseudotile = true;
                # You probably want this
                preserve_split = true;
                # This feels like BSPWM
                force_split = 2;
              };

              bind = [
                "$mainMod, Return, exec, ${lib.getExe pkgs.uwsm} app -- $terminal"

                "$mainMod, C, killactive,"
                "$mainMod, M, exit,"
                "$mainMod, V, togglefloating,"
                "$mainMod, P, pseudo," # dwindle
                "$mainMod, J, togglesplit," # dwindle
              ];

              bindl = [ ];

              device = {
                name = "sino-wealth-mechanical-keyboard";
                kb_layout = "us-esc, br-esc";
                kb_options = "grp:alt_space_toggle";
              };

              exec-once = [ ];

              input = {
                follow_mouse = 2;
                kb_layout = "br-esc";
                numlock_by_default = true;
                touchpad.natural_scroll = true;
              };

              # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
              master.new_status = "master";

              # https://wiki.hyprland.org/Configuring/Variables/#misc
              misc = {
                # Set to 0 or 1 to disable the anime mascot wallpapers
                force_default_wallpaper = -1;
                # If true disables the random hyprland logo / anime girl background. :(
                disable_hyprland_logo = true;
              };

              monitor = [
                "eDP-1,1920x1080@144,2560x0,1"
                "HDMI-A-1,2560x1080@60,0x0,1"
              ];
            };
        };
      };
  };
}
