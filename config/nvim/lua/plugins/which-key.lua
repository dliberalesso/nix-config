local enabled = true

local M = {
  "folke/which-key.nvim",

  event = "VeryLazy", -- Sets the loading event to 'VimEnter'

  config = function() -- This is the function that runs, AFTER loading
    require("which-key").setup()

    -- Document existing key chains
    require("which-key").register {
      ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
      ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
      ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
      -- ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
      ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
      ["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
      -- ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
    }
    -- visual mode
    require("which-key").register({
      ["<leader>g"] = { "[G]it" },
    }, { mode = "v" })
  end,
}

return enabled and M or {}
