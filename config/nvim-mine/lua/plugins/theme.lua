local enabled = true

if not enabled then
  return {}
end

return {
  "catppuccin/nvim",
  name = "catppuccin",

  dependencies = {
    {
      "rachartier/tiny-devicons-auto-colors.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
  },

  lazy = false,

  config = function(_, opts)
    require("catppuccin").setup(opts)

    require("tiny-devicons-auto-colors").setup {
      colors = require("catppuccin.palettes").get_palette(opts.flavour),
    }

    vim.cmd.colorscheme "catppuccin"
  end,

  opts = {
    flavour = "mocha",

    integrations = {
      gitsigns = true,
      indent_blankline = { enabled = true },
      markdown = true,

      mini = {
        enabled = true,
        indentscope_color = "mauve",
      },

      native_lsp = {
        enabled = true,

        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },

        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },

        inlay_hints = {
          background = true,
        },
      },

      neotree = true,
      noice = true,
      notify = true,
      telescope = { enabled = true },
      treesitter = true,
      which_key = true,
    },
  },
}
