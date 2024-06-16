local M = {}

function M.setup()
  vim.opt.timeout = true
  vim.opt.timeoutlen = 300
  vim.opt.updatetime = 250
end

return M
