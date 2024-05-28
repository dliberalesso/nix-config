return {
  {
    "echasnovski/mini.basics",
    lazy = false,
    opts = {
      options = { win_borders = "bold" },
      mappings = {
        option_toggle_prefix = [[<leader>t]],
        windows = true,
        move_with_alt = true,
      },
    },
  },
  {
    "echasnovski/mini.statusline",
    dependencies = { "rachartier/tiny-devicons-auto-colors.nvim" },
    event = "VeryLazy",
    opts = { set_vim_settings = false },
  },
  {
    "echasnovski/mini.ai",
    event = { "BufReadPost", "BufNewFile" },
    opts = { n_lines = 500 },
  },
  {
    "echasnovski/mini.align",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "echasnovski/mini.pairs",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "echasnovski/mini.surround",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "echasnovski/mini.trailspace",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
}
