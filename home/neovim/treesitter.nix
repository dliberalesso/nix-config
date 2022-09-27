{ nvim-treesitter, ... }:

{
  plugin = nvim-treesitter;
  type = "lua";
  config = ''
    require('nvim-treesitter.configs').setup {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
      },
      indent = {
        enable = true
      }
    }
  '';
}
