return {
  {
    "rachartier/tiny-devicons-auto-colors.nvim",

    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",

    lazy = false,

    config = function(_, opts)
      require("catppuccin").setup(opts)

      local palette = require("catppuccin.palettes").get_palette(opts.flavour)
      require("tiny-devicons-auto-colors").setup { colors = palette }

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
  },
}
