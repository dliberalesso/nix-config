return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup {
      flavour = "mocha",
      integrations = {
        mini = { enabled = true },
        treesitter = true,
        which_key = true,
      },
    }

    vim.cmd.colorscheme "catppuccin"
  end,
}
