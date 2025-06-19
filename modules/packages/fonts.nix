{
  unify.modules.gui.nixos =
    {
      pkgs,
      ...
    }:
    {
      fonts.packages = with pkgs; [
        fira-code
        fira-code-symbols
        font-awesome
        material-icons
        monaspace
        nerd-fonts.jetbrains-mono
        noto-fonts
        symbola
      ];
    };
}
