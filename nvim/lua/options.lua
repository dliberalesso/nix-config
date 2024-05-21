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
vim.opt.undodir = os.getenv "HOME" .. "/.cache/nvim/undodir"
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
