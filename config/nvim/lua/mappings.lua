return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      n = {
        ["<Leader>xx"] = { "<cmd>source %<CR>", desc = "Execute the current file" },
      },
    },
  },
}
