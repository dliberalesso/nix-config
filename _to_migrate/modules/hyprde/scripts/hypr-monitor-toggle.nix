# credit goes to https://github.com/miyl

{
  pkgs,
  ...
}:
pkgs.writeShellScriptBin "hypr-monitor-toggle" ''
  move_all_workspaces_to_monitor() {
    TARGET_MONITOR="$1"

    hyprctl workspaces | rg ^workspace | cut --delimiter ' ' --fields 3 | xargs -I '{}' hyprctl dispatch moveworkspacetomonitor '{}' "$TARGET_MONITOR"
  }

  INTERNAL_MONITOR="eDP-1"
  EXTERNAL_MONITOR="HDMI-A-1"

  NUM_MONITORS=$(hyprctl monitors all | rg --count Monitor)
  NUM_MONITORS_ACTIVE=$(hyprctl monitors | rg --count Monitor)

  # Turn off the laptop monitor if it + another monitor is active
  if [ "$NUM_MONITORS_ACTIVE" -ge 2 ] && hyprctl monitors | cut --delimiter ' ' --fields 2 | rg --quiet ^$INTERNAL_MONITOR; then
      move_all_workspaces_to_monitor $EXTERNAL_MONITOR
      hyprctl keyword monitor "$INTERNAL_MONITOR, disable"
      hyprctl dispatch workspace 1
      exit
  fi

  INTERNAL_MONITOR_WITH_RES = "eDP-1,1920x1080@144,2560x0,1"
  EXTERNAL_MONITOR_WITH_RES = "HDMI-A-1,2560x1080@60,0x0,1"

  # For dynamically toggling which monitor is active later via a keybind
  if [ "$NUM_MONITORS" -gt 1 ]; then # Handling multiple monitors
    if hyprctl monitors | cut --delimiter ' ' --fields 2 | rg --quiet ^$EXTERNAL_MONITOR; then
      hyprctl keyword monitor $INTERNAL_MONITOR_WITH_RES
      move_all_workspaces_to_monitor $INTERNAL_MONITOR
      hyprctl keyword monitor "$EXTERNAL_MONITOR, disable"
    else
      hyprctl keyword monitor $EXTERNAL_MONITOR_WITH_RES
      move_all_workspaces_to_monitor $EXTERNAL_MONITOR
      hyprctl keyword monitor "$INTERNAL_MONITOR, disable"
    fi
  else  # If the external monitor is disconnected without running this script first, it might become the case that no monitor is on - therefore turn on the laptop monitor!
      hyprctl keyword monitor $INTERNAL_MONITOR_WITH_RES
      move_all_workspaces_to_monitor $INTERNAL_MONITOR
  fi
''
