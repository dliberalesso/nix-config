return {
  {
    "echasnovski/mini.comment",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
}
