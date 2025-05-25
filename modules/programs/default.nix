{
  pkgs,
  ...
}:
{
  imports = [
    ./espanso
    ./wezterm

    ./irpf.nix
    ./spicetify.nix
  ];

  home-manager.users.dli50 = {
    home.packages = with pkgs; [
      qalculate-qt

      google-chrome
      vesktop

      prismlauncher
      obsidian
    ];

    programs.zathura.enable = true;
  };
}
