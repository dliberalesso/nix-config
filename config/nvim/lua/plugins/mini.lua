return {
  "echasnovski/mini.basics",
  {
    "echasnovski/mini.ai",
    event = { "BufReadPre", "BufNewFile" },
    opts = { n_lines = 500 }
  },
  {
    "echasnovski/mini.align",
    event = { "BufReadPre", "BufNewFile" },
    config = true
  },
  {
    "echasnovski/mini.comment",
    event = { "BufReadPre", "BufNewFile" },
    config = true
  },
  {
    "echasnovski/mini.diff",
    event = { "BufReadPre", "BufNewFile" },
    opts = { view = { style = "sign" } }
  },
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    config = true
  },
  {
    "echasnovski/mini.pairs",
    event = { "BufReadPre", "BufNewFile" },
    config = true
  },
  {
    "echasnovski/mini.surround",
    event = { "BufReadPre", "BufNewFile" },
    config = true
  },
  {
    "echasnovski/mini.trailspace",
    event = { "BufReadPre", "BufNewFile" },
    config = true
  },
  {
    "echasnovski/mini.statusline",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { set_vim_settings = false }
  }
}
