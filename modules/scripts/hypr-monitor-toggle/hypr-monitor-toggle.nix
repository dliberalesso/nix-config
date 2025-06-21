{
  unify.modules.hyprde.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "hypr-monitor-toggle";

          runtimeInputs = builtins.attrValues {
            inherit (pkgs) findutils hyprland ripgrep;
          };

          text = builtins.readFile ./hypr-monitor-toggle.sh;
        })
      ];
    };
}
