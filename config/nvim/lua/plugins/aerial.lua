---@type LazySpec
return {
  "stevearc/aerial.nvim",

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },

  event = "User AstroFile",

  config = function(_, opts)
    require("aerial").setup(opts)

    vim.keymap.set("n", "<leader>lS", "<cmd>AerialToggle!<cr>", { desc = "Symbols outline" })
  end,

  opts = function()
    local opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = { min_width = 28 },
      show_guides = true,
      filter_kind = false,
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
      keymaps = {
        ["[y"] = "actions.prev",
        ["]y"] = "actions.next",
        ["[Y"] = "actions.prev_up",
        ["]Y"] = "actions.next_up",
        ["{"] = false,
        ["}"] = false,
        ["[["] = false,
        ["]]"] = false,
      },
    }

    local large_buf = vim.tbl_get(require("astrocore").config, "features", "large_buf")
    if large_buf then
      opts.disable_max_lines, opts.disable_max_size = large_buf.lines, large_buf.size
    end

    return opts
  end,
}
