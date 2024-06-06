-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.comment.ts-comments-nvim" },
  { import = "astrocommunity.motion.mini-surround" },
  -- import/override with your plugins folder
}
