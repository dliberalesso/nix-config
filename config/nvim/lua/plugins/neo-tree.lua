local enabled = true

local M = {
  "nvim-neo-tree/neo-tree.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim",
  },

  cmd = "Neotree",

  opts = {
    close_if_last_window = true,
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      hijack_netrw_behavior = "open_current",
    },
  },

  init = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
      callback = function()
        local f = vim.fn.expand "%:p"
        if vim.fn.isdirectory(f) ~= 0 then
          vim.cmd("Neotree current dir=" .. f)
          vim.api.nvim_clear_autocmds { group = "NeoTreeInit" }
        end
      end,
    })
  end,
}

return enabled and M or {}
