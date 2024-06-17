local M = {}

function M.init() end

function M.setup()
  vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    group = vim.api.nvim_create_augroup("highlightyank", { clear = true }),
    pattern = "*",
    callback = function()
      vim.highlight.on_yank()
    end,
  })
end

return M
