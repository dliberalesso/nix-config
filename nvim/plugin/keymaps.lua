local set = vim.keymap.set

-- Set highlight on search, but clear on pressing <Esc> in normal mode
set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
-- set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
-- set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
set({ "n", "v", "o", "x" }, "<left>", "")
set({ "n", "v", "o", "x" }, "<right>", "")
set({ "n", "v", "o", "x" }, "<up>", "")
set({ "n", "v", "o", "x" }, "<down>", "")

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
-- set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
-- set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
-- set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
-- set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Source current file
set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })
