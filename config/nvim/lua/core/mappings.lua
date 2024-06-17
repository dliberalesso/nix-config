local M = {}

function M.setup(maps)
  maps.n["<Leader>pi"] = {
    function()
      require("lazy").install()
    end,
    desc = "Plugins Install",
  }
  maps.n["<Leader>pp"] = {
    function()
      require("lazy").profile()
    end,
    desc = "Plugins Profile",
  }
  maps.n["<Leader>ps"] = {
    function()
      require("lazy").home()
    end,
    desc = "Plugins Status",
  }
  maps.n["<Leader>pS"] = {
    function()
      require("lazy").sync()
    end,
    desc = "Plugins Sync",
  }
  maps.n["<Leader>pu"] = {
    function()
      require("lazy").check()
    end,
    desc = "Plugins Check Updates",
  }
  maps.n["<Leader>pU"] = {
    function()
      require("lazy").update()
    end,
    desc = "Plugins Update",
  }

  require("core.utils").set_mappings(maps)
end

return M
