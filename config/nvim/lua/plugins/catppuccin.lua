---@type LazySpec
return {
  "catppuccin/nvim",
  name = "catppuccin",
  init = function()
    vim.cmd.colorscheme "catppuccin"
  end,
  config = true,
  ---@type CatppuccinOptions
  -- opts = {
  --   integrations = {
  --     aerial = true,
  --     alpha = true,
  --     cmp = true,
  --     dap = true,
  --     dap_ui = true,
  --     gitsigns = true,
  --     illuminate = true,
  --     indent_blankline = true,
  --     markdown = true,
  --     mini = { enabled = true },
  --     native_lsp = { enabled = true },
  --     neotree = true,
  --     notify = true,
  --     semantic_tokens = true,
  --     symbols_outline = true,
  --     telescope = true,
  --     treesitter = true,
  --     ts_rainbow = false,
  --     ufo = true,
  --     which_key = true,
  --     window_picker = true,
  --   },
  -- },
}
