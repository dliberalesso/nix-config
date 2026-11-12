{
  inputs,
  ...
}:
{
  unify.modules.wsl.nixos =
    {
      hostConfig,
      lib,
      ...
    }:
    {
      imports = [
        inputs.nixos-wsl.nixosModules.wsl
      ];

      hardware.graphics.enable = lib.mkForce false;

      wsl = {
        enable = true;
        defaultUser = hostConfig.user.username;
        startMenuLaunchers = false;

        ssh-agent.enable = true;

        wslConf = {
          automount.root = "/mnt";
          interop.appendWindowsPath = false;
          network.hostname = hostConfig.name;
        };
      };
    };

  unify.modules.wsl.home =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # Copy only the patched script so nixwsl doesn't retain the wezterm GUI closure.
      shellIntegration = pkgs.runCommand "wezterm-shell-integration" { } ''
        install -Dm644 ${pkgs.wezterm}/etc/profile.d/wezterm.sh -t $out/etc/profile.d
      '';
    in
    {
      programs.zsh.initContent = lib.mkIf config.programs.zsh.enable ''
        source "${shellIntegration}/etc/profile.d/wezterm.sh"
      '';
    };
}
