return {
  -- TODO: replace with nvim-highlight-colors: https://github.com/brenoprata10/nvim-highlight-colors
  "NvChad/nvim-colorizer.lua",
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>uz"] = { "<Cmd>ColorizerToggle<CR>", desc = "Toggle color highlight" }
      end,
    },
  },
  event = "User AstroFile",
  cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
  opts = { user_default_options = { names = false } },
  config = function(_, opts)
    local colorizer = require "colorizer"
    colorizer.setup(opts)
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
      if vim.t[tab].bufs then
        vim.tbl_map(function(buf)
          colorizer.attach_to_buffer(buf)
        end, vim.t[tab].bufs)
      end
    end
  end,
}
