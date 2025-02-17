return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  enabled = require("nixCatsUtils").enableForCategory("file-manager"),
  cmd = { "Oil" },
}
