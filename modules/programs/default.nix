{
  pkgs,
  ...
}:
{
  imports = [
    ./espanso
  ];

  home-manager.users.dli50 = {
    imports = [
      ./irpf.nix
      ./spicetify.nix
    ];

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
