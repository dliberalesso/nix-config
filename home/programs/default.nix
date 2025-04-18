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

    qalculate-gtk

    google-chrome

    prismlauncher
    obsidian
  ];
}
