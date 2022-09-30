{ nvim-colorizer-lua, ... }:

{
  plugin = nvim-colorizer-lua;
  type = "lua";
  config = ''
    require('colorizer').setup {
      user_default_options = {
        names = false
      }
    }
  '';
}
