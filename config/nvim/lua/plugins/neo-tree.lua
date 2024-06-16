---@type LazySpec[]
return {
  {
    "nvim-neo-tree/neo-tree.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim",
    },

    cmd = "Neotree",

    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
        callback = function()
          local f = vim.fn.expand("%:p")
          if vim.fn.isdirectory(f) ~= 0 then
            vim.cmd("Neotree current dir=" .. f)
            vim.api.nvim_clear_autocmds({ group = "NeoTreeInit" })
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
      source_selector = {
        winbar = true,
        content_layout = "center",
      },
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
  },
  require("core.utils").core_spec("mappings", {
    opts = function(_, maps)
      maps.n["<leader>e"] = {
        function()
          if vim.bo.filetype == "neo-tree" then
            vim.cmd.wincmd("p")
          else
            require("neo-tree.command").execute({ reveal = true, source = "last" })
          end
        end,
        desc = "Explorer",
      }
      maps.n["<leader>E"] = {
        function()
          require("neo-tree.command").execute({ action = "close" })
        end,
        desc = "which_key_ignore",
      }
      maps.n["<leader>fe"] = {
        function()
          require("neo-tree.command").execute({ reveal = true, source = "filesystem" })
        end,
        desc = "File Explorer",
      }
      maps.n["<leader>be"] = {
        function()
          require("neo-tree.command").execute({ reveal = true, source = "buffers" })
        end,
        desc = "Buffer Explorer",
      }
      maps.n["<leader>ge"] = {
        function()
          require("neo-tree.command").execute({ reveal = true, source = "git_status" })
        end,
        desc = "Git Explorer",
      }
    end,
  }),
}
