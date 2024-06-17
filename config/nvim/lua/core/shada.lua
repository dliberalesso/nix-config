local M = {}

function M.setup(opts)
  -- Loading shada is SLOW, so we're going to load it manually,
  -- after UI-enter so it doesn't block startup.
  vim.o.shada = "!,'1000,<50,s10,h"
  pcall(vim.cmd.rshada, { bang = true })
end

return M
