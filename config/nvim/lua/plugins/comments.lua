local enabled = true

local M = {
  {
    "folke/ts-comments.nvim",
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

return enabled and M or {}
