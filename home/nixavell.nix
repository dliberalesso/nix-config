{ pkgs
, ...
}: {
  imports = [
    ./common
    ./programs/spicetify.nix
  ];

  home.packages = with pkgs; [
    kdePackages.kcalc

    wezterm

    google-chrome

    prismlauncher
    obsidian
    # spotify
  ];
}
