{ dracula-nvim, ... }:

{
  plugin = dracula-nvim;
  type = "lua";
  config = ''
    vim.o.termguicolors = true
    vim.cmd('colorscheme dracula')
  '';
}
