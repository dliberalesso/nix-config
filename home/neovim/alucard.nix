{ colors, dracula-nvim, ... }:

{
  plugin = dracula-nvim;
  type = "lua";
  config = with colors; ''
    require('dracula').setup {
      colors = {
        bg = "${bg}",
        fg = "${fg}",
        selection = "${selection}",
        comment = "${comment}",
        red = "${red}",
        orange = "${orange}",
        yellow = "${yellow}",
        green = "${green}",
        purple = "${purple}",
        cyan = "${cyan}",
        pink = "${pink}",
        bright_red = "${color_9}",
        bright_green = "${color_10}",
        bright_yellow = "${color_11}",
        bright_blue = "${color_12}",
        bright_magenta = "${color_13}",
        bright_cyan = "${color_14}",
        bright_white = "${color_15}",
        menu = "${bgdark}",
        visual = "${subtle}",
        gutter_fg = "#4B5263",
        nontext = "#3B4048",
        white = "#ABB2BF",
        black = "${bgdarker}"
      },

      italic_comment = true
    }

    vim.cmd('colorscheme dracula')
  '';
}
