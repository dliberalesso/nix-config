return {
  {
    "echasnovski/mini.comment",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
}
