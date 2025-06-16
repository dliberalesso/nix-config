{
  unify.home = {
    home.shell.enableFishIntegration = true;

    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        set -g fish_greeting
        set -gx fish_term24bit 1
        set -gx COLORTERM truecolor
      '';
    };
  };

  unify.nixos =
    {
      pkgs,
      ...
    }:
    {
      environment.shells = [ pkgs.fish ];

      programs.fish.enable = true;

      users.defaultUserShell = pkgs.fish;
    };
}
