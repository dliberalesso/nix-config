{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nvd
  ];

  programs.nh = {
    enable = true;

    clean = {
      enable = true;
      extraArgs = "--keep 3 --keep-since 8d";
    };

    flake = "/home/dli50/nix-config";
  };
}
