{ lualine-nvim, ... }:

{
  plugin = lualine-nvim;
  type = "lua";
  config = ''
    require('lualine').setup()
  '';
}
