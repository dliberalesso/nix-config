{
  pkgs,
  ...
}:
{
  imports = [
    ./irpf.nix
    ./spicetify.nix
  ];

  home.packages = with pkgs; [
    wezterm

    qalculate-qt

    google-chrome

    prismlauncher
    obsidian
  ];
}
