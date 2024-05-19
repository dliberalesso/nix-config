-- [[ Setting options ]]

-- Set <space> as the leader key
-- Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- We have Nerd Fonts
vim.g.have_nerd_font = true

-- Disable mouse
vim.opt.mouse = ""

-- A lot of plugins depends on hidden true
vim.opt.hidden = true

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Statusline
vim.opt.laststatus = 3

-- Command line height
-- vim.opt.cmdheight = 2
vim.opt.cmdheight = 0

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Hide tabline
vim.opt.showtabline = 0

-- Tab settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4

-- Enable smart indenting
vim.opt.smartindent = true
vim.opt.breakindent = true

-- No wrap
vim.opt.wrap = false

-- Minimal number of screen lines/columns to keep around the cursor.
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

-- Set highlight on search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Preview substitutions live
vim.opt.inccommand = "split"

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Better undo history
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.cache/nvim/undodir'
vim.opt.undofile = true

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor
vim.opt.list = true
vim.opt.listchars = "tab:» ,space: ,trail:•,extends:→,precedes:←,nbsp:␣"

-- [[ Basic Keymaps ]]

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require("lazy").setup(
  {
    -- Install colorscheme
    {
      "catppuccin/nvim",
      name = "catppuccin",
      lazy = false,
      priority = 1000,
      config = function()
        require("catppuccin").setup({
          flavour = "mocha",
          integrations = {
            mini = { enabled = true },
            treesitter = true,
            which_key = true
          }
        })

        vim.cmd.colorscheme "catppuccin"
      end
    },

    -- Install `mini.nvim` modules
    "echasnovski/mini.basics",
    {
      "echasnovski/mini.ai",
      event = { "BufReadPre", "BufNewFile" },
      opts = { n_lines = 500 }
    },
    {
      "echasnovski/mini.align",
      event = { "BufReadPre", "BufNewFile" },
      config = true
    },
    {
      "echasnovski/mini.comment",
      event = { "BufReadPre", "BufNewFile" },
      config = true
    },
    {
      "echasnovski/mini.diff",
      event = { "BufReadPre", "BufNewFile" },
      opts = { view = { style = "sign" } }
    },
    {
      "echasnovski/mini.indentscope",
      event = { "BufReadPre", "BufNewFile" },
      config = true
    },
    {
      "echasnovski/mini.pairs",
      event = { "BufReadPre", "BufNewFile" },
      config = true
    },
    {
      "echasnovski/mini.surround",
      event = { "BufReadPre", "BufNewFile" },
      config = true
    },
    {
      "echasnovski/mini.trailspace",
      event = { "BufReadPre", "BufNewFile" },
      config = true
    },
    {
      "echasnovski/mini.statusline",
      event = "VeryLazy",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = { set_vim_settings = false }
    },
  },
  -- Set opts for `lazy.nvim`
  {
    install = { colorscheme = { "catppuccin" } },
    performance = {
      rtp = {
        disabled_plugins = {
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          "netrwFileHandlers",
          "gzip",
          "zip",
          "zipPlugin",
          "tar",
          "tarPlugin",
          "getscript",
          "getscriptPlugin",
          "vimball",
          "vimballPlugin",
          "2html_plugin",
          "tohtml",
          "logipat",
          "rrhelper",
          "spellfile_plugin",
          "matchit",

          "tutor",
          "rplugin",
          "syntax",
          "synmenu",
          "optwin",
          "compiler",
          "bugreport",
          "ftplugin",
        }
      }
    }
  }
)
