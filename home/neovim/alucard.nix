{ config, dracula-vim, ... }:

{
  plugin = dracula-vim;
  type = "lua";
  config = with config.theme.colors; ''
    vim.cmd [[
      set termguicolors

      let g:dracula#palette           = {}
      let g:dracula#palette.fg        = ['${fg}', 231]

      let g:dracula#palette.bglighter = ['${bglighter}',  59]
      let g:dracula#palette.bglight   = ['${bglight}',  59]
      let g:dracula#palette.bg        = ['${bg}',  59]
      let g:dracula#palette.bgdark    = ['${bgdark}',  17]
      let g:dracula#palette.bgdarker  = ['${bgdarker}',  16]

      let g:dracula#palette.comment   = ['${comment}', 103]
      let g:dracula#palette.selection = ['${selection}',  60]
      let g:dracula#palette.subtle    = ['${subtle}',  60]

      let g:dracula#palette.cyan      = ['${cyan}', 159]
      let g:dracula#palette.green     = ['${green}', 157]
      let g:dracula#palette.orange    = ['${orange}', 223]
      let g:dracula#palette.pink      = ['${pink}', 218]
      let g:dracula#palette.purple    = ['${purple}', 147]
      let g:dracula#palette.red       = ['${red}', 217]
      let g:dracula#palette.yellow    = ['${yellow}', 229]

      let g:dracula#palette.color_0  = '${color_0}'
      let g:dracula#palette.color_1  = '${color_1}'
      let g:dracula#palette.color_2  = '${color_2}'
      let g:dracula#palette.color_3  = '${color_3}'
      let g:dracula#palette.color_4  = '${color_4}'
      let g:dracula#palette.color_5  = '${color_5}'
      let g:dracula#palette.color_6  = '${color_6}'
      let g:dracula#palette.color_7  = '${color_7}'
      let g:dracula#palette.color_8  = '${color_8}'
      let g:dracula#palette.color_9  = '${color_9}'
      let g:dracula#palette.color_10 = '${color_10}'
      let g:dracula#palette.color_11 = '${color_11}'
      let g:dracula#palette.color_12 = '${color_12}'
      let g:dracula#palette.color_13 = '${color_13}'
      let g:dracula#palette.color_14 = '${color_14}'
      let g:dracula#palette.color_15 = '${color_15}'
      
      colorscheme dracula
    ]]
  '';
}
