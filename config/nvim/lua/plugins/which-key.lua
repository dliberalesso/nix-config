local enabled = true

if not enabled then
  return {}
end

local get_icon = require("icons").get_icon
local icons = {
  b = { desc = get_icon("Tab", 1) .. "Buffers" },
  bs = { desc = get_icon("Sort", 1) .. "Sort Buffers" },
  c = { desc = get_icon("Run", 1) .. "Compiler" },
  d = { desc = get_icon("Debugger", 1) .. "Debugger" },
  dc = { desc = get_icon("Docs", 1) .. "Docs" },
  f = { desc = get_icon("Search", 1) .. "Find" },
  g = { desc = get_icon("Git", 1) .. "Git" },
  l = { desc = get_icon("ActiveLSP", 1) .. "LSP" },
  p = { desc = get_icon("Package", 1) .. "Packages" },
  S = { desc = get_icon("Session", 1) .. "Session" },
  t = { desc = get_icon("Terminal", 1) .. "Terminal" },
  tt = { desc = get_icon("Test", 1) .. "Test" },
  u = { desc = get_icon("Window", 1) .. "UI" },
}

return {
  "folke/which-key.nvim",

  event = "VeryLazy", -- Sets the loading event to 'VimEnter'

  config = function() -- This is the function that runs, AFTER loading
    local which_key = require "which-key"

    which_key.setup()

    -- Document existing key chains
    which_key.register {
      ["<leader>c"] = { icons.c },
      ["<leader>f"] = { icons.f },
      ["<leader>g"] = { icons.g },
      -- ["<leader>r"] = { "[R]ename" },
      -- ["<leader>s"] = { "[S]earch" },
      ["<leader>u"] = { icons.u },
      -- ["<leader>w"] = { "[W]orkspace" },
    }
    -- visual mode
    which_key.register({
      ["<leader>g"] = { icons.g },
    }, { mode = "v" })
  end,
}
