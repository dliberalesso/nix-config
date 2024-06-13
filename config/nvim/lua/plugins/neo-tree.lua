---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim",
  },

  cmd = "Neotree",

  ---@return LazyKeysSpec[]
  keys = {
    -- TODO: Add `<leader>e` to focus, respecting what is already opened
    -- TODO: Add `<leader>e` to focus last buffer when inside neo-tree
    -- TODO: Maybe add `<leader>eq` to close
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute { focus = true, reveal = true, source = "last" }
      end,
      desc = "File Explorer",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute { toggle = true, reveal = true, source = "last" }
      end,
      desc = "File Explorer",
    },
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute { toggle = true, reveal = true, source = "filesystem" }
      end,
      desc = "File Explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute { toggle = true, reveal = true, source = "buffers" }
      end,
      desc = "Buffer Explorer",
    },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute { toggle = true, reveal = true, source = "git_status" }
      end,
      desc = "Git Explorer",
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

  opts = {
    close_if_last_window = true,
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(_)
          vim.opt_local.signcolumn = "auto"
          vim.opt_local.foldcolumn = "0"
        end,
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      hijack_netrw_behavior = "open_current",
    },
    sources = { "filesystem", "buffers", "git_status", "document_symbols" },
    window = {
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "none",
        ["[b"] = "prev_source",
        ["]b"] = "next_source",
      },
      width = 30,
    },
  },
}
