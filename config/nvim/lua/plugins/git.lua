---@type LazySpec[]
return {
  {
    "sindrets/diffview.nvim",

    -- TODO: add a custom event like
    -- event = "User AstroFile",
    -- event = { "BufReadPost", "BufNewFile" },

    cmd = { "DiffviewOpen" },

    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { winbar_info = true },
        file_history = { winbar_info = true },
      },
      hooks = {
        diff_buf_read = function(bufnr)
          vim.b[bufnr].view_activated = false
        end,
      },
    },
  },
}
