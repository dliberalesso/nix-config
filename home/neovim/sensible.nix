{ vim-sensible, ... }:

{
  plugin = vim-sensible;
  type = "lua";
  config = ''
    vim.cmd [[
      set termguicolors
      set number relativenumber
    ]]
  '';
}
