{ config, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
  };

  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nix-config/nvim";
    };
  };
}
