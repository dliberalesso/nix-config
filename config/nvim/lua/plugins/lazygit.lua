return {
  "kdheepak/lazygit.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",

    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        mappings = {
          n = {
            ["<Leader>gg"] = { "<cmd>LazyGit<cr>", desc = "LazyGit" },
          },
        },
      },
    },
  },

  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
}
