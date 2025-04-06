{
  pkgs,
  ...
}:
{
  imports = [
    ./common
    ./programs/ghostty.nix
    ./programs/spicetify.nix
    ./scripts
  ];

  home.packages = with pkgs; [
    kdePackages.kcalc

    wezterm

    google-chrome

    prismlauncher
    obsidian
  ];

  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
  };
}
