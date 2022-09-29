{ dracula-vim, ... }:

{
  plugin = dracula-vim;
  type = "lua";
  config = ''
    vim.o.termguicolors = true
    vim.cmd('colorscheme dracula')
  '';
}
