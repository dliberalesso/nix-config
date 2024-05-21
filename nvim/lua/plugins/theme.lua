return {
  {
    "catppuccin/nvim",
    name = "catppuccin",

    lazy = false,
    priority = 1000,

    config = function()
      require("catppuccin").setup {
        flavour = "mocha",
        integrations = {
          indent_blankline = { enabled = true },
          mini = {
            enabled = true,
            indentscope_color = "mauve",
          },
          neotree = true,
          telescope = { enabled = true },
          treesitter = true,
          which_key = true,
        },
      }

      vim.cmd.colorscheme "catppuccin"
    end,
  },
  {
    "rachartier/tiny-devicons-auto-colors.nvim",

    dependencies = { "nvim-tree/nvim-web-devicons" },

    event = "VeryLazy",

    config = function()
      local theme_colors = require("catppuccin.palettes").get_palette "mocha"

      require("tiny-devicons-auto-colors").setup {
        colors = theme_colors,
      }
    end,
  },
}