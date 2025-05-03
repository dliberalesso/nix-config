{
  pkgs,
  ...
}:
{
  imports = [
    ./espanso

    ./irpf.nix
    ./spicetify.nix
  ];

  home-manager.users.dli50 = {
    home.packages = with pkgs; [
      wezterm

      qalculate-qt

      google-chrome
      vesktop

      prismlauncher
      obsidian
    ];

    programs.zathura.enable = true;
  };
}
