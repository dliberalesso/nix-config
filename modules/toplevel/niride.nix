{
  unify.modules.niride.nixos =
    { hostConfig, pkgs, ... }:
    {
      environment = {
        sessionVariables.NIXOS_OZONE_WL = "1";

        systemPackages = with pkgs; [
          nautilus
          wev
        ];
      };

      services.udev.extraRules = ''
        ACTION=="change", SUBSYSTEM=="button", ENV{KEY}=="Lid", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="niri-lid-handler.service"
        ACTION=="change", SUBSYSTEM=="button", ENV{KEY}=="Lid", RUN+="${pkgs.systemd}/bin/systemctl --user --machine=${hostConfig.user.username}@.host start niri-lid-handler.service"
      '';

      programs = {
        dms-shell = {
          enable = true;

          enableCalendarEvents = false;
          enableDynamicTheming = false;
          enableVPN = false;
        };

        niri.enable = true;
      };

      security.polkit.enable = true;
      security.pam.services.dms-shell = { };

      services = {
        displayManager.dms-greeter = {
          enable = true;

          compositor.name = "niri";
        };

        geoclue2.enable = true;
        power-profiles-daemon.enable = true;
        upower.enable = true;
      };

      xdg.portal = {
        enable = true;
        config.niri.default = [
          "gnome"
          "gtk"
        ];
        config.niri."org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
        extraPortals = [
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-gtk
        ];
      };
    };

  unify.modules.niride.home =
    { pkgs, ... }:
    let
      niri-lid-handler = pkgs.writeShellApplication {
        name = "niri-lid-handler";
        runtimeInputs = [
          pkgs.niri
          pkgs.coreutils
          pkgs.gawk
        ];
        text = ''
          # Script to toggle internal monitor based on lid state in Niri
          LID_STATE_FILE=$(find /proc/acpi/button/lid -maxdepth 2 -type f -name state 2>/dev/null | head -n 1)

          if [ -z "$LID_STATE_FILE" ] || [ ! -f "$LID_STATE_FILE" ]; then
              echo "Lid state file not found. Skipping."
              exit 0
          fi

          LID_STATE=$(awk '{print $2}' "$LID_STATE_FILE")
          INTERNAL_MONITOR="eDP-1"

          # Check if we are running in a Niri session
          if [ -z "''${NIRI_SOCKET:-}" ]; then
              # Try to find the socket if not in environment
              NIRI_SOCKET=$(find "/run/user/$(id -u)" -maxdepth 1 -type s -name 'niri-internal-*' 2>/dev/null | head -n 1)
              if [ -n "$NIRI_SOCKET" ]; then
                  export NIRI_SOCKET
              else
                  echo "Niri socket not found. Are you in a Niri session?"
                  exit 0
              fi
          fi

          for _ in 1 2 3 4 5; do
              if niri msg outputs >/dev/null 2>&1; then
                  break
              fi
              sleep 0.2
          done

          if [ "$LID_STATE" = "closed" ]; then
              echo "Lid closed. Turning off $INTERNAL_MONITOR"
              niri msg output "$INTERNAL_MONITOR" off || true
          else
              echo "Lid open. Turning on $INTERNAL_MONITOR"
              niri msg output "$INTERNAL_MONITOR" on || true
          fi
        '';
      };
    in
    {
      home.packages = [
        niri-lid-handler
        pkgs.xwayland-satellite
      ];

      home.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";

      systemd.user.services.niri-lid-handler = {
        Unit = {
          Description = "Niri Lid Handler";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${niri-lid-handler}/bin/niri-lid-handler";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };

      services.polkit-gnome.enable = true;
    };
}
