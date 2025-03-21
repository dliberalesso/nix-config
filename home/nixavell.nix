{ pkgs
, ...
}: {
  imports = [
    ./common
  ];

  home.packages = with pkgs; [
    kdePackages.kcalc

    wezterm

    google-chrome

    prismlauncher
    obsidian
    spotify
  ];
}
