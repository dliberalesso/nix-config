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

    google-chrome

    prismlauncher
    obsidian
  ];
}
