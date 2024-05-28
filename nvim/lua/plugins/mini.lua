return {
  {
    "echasnovski/mini.basics",
    event = "VimEnter",
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
