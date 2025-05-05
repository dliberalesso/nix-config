{
  lib,
  pkgs,
  ...
}:
{
  home-manager.users.dli50 = with pkgs; {
    home.packages = with lib; [
      (writeShellScriptBin "rofi-launcher" ''
        # check if rofi is already running
        if ${getExe' procps "pidof"} rofi > /dev/null; then
          ${getExe' procps "pkill"} rofi
        fi

        ${getExe rofi-wayland} -show drun -run-command \
        "${getExe uwsm} app -- {cmd}"
      '')
    ];

    programs.rofi = {
      enable = true;
      package = rofi-wayland;
    };
  };
}
