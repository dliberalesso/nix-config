return {
  {
    "echasnovski/mini.diff",
    event = { "BufReadPre", "BufNewFile" },
    opts = { view = { style = "sign" } },
  },
  {
    "kdheepak/lazygit.nvim",

    dependencies = { "nvim-lua/plenary.nvim" },

    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },

    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Lazy[G]it" },
    },
  },
}
