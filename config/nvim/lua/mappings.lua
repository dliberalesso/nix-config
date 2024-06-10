---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      n = {
        ["<Leader>xx"] = { "<cmd>source %<cr>", desc = "Execute the current file" },
      },
    },
  },
}
