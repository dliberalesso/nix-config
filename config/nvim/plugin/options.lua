-- We have Nerd Fonts
vim.g.have_nerd_font = true

-- Fix clipboard on wsl
vim.g.clipboard = {
  name = "WslClipboard",
  copy = {
    ["+"] = "clip.exe",
    ["*"] = "clip.exe",
  },
  paste = {
    ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  },
  cache_enabled = 0,
}

local opt = vim.opt

-- Disable mouse
opt.mouse = ""

-- A lot of plugins depends on hidden true
opt.hidden = true

-- Make line numbers default
opt.number = true
opt.relativenumber = true

-- Keep signcolumn on by default
opt.signcolumn = "yes"

-- Show which line your cursor is on
opt.cursorline = true

-- Statusline
opt.laststatus = 3

-- Command line height
-- vim.opt.cmdheight = 2
opt.cmdheight = 0

-- Don't show the mode, since it's already in status line
opt.showmode = false

-- Hide tabline
opt.showtabline = 0

-- Tab settings
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.shiftwidth = 4

-- Enable smart indenting
opt.smartindent = true
opt.breakindent = true

-- No wrap
opt.wrap = false

-- Minimal number of screen lines/columns to keep around the cursor.
opt.scrolloff = 10
opt.sidescrolloff = 10

-- Set highlight on search
opt.hlsearch = true
opt.incsearch = true

-- Preview substitutions live
opt.inccommand = "split"

-- Case-insensitive searching UNLESS \C or capital in search
opt.ignorecase = true
opt.smartcase = true

-- Better undo history
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv "HOME" .. "/.cache/nvim/undodir"
opt.undofile = true

-- Decrease update time
opt.updatetime = 250
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor
opt.list = true
opt.listchars = "tab:» ,space: ,trail:•,extends:→,precedes:←,nbsp:␣"
