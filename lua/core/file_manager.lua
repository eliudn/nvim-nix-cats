return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	enabled = require("nixCatsUtils").enableForCategory("file-manager"),
	keys = {
		{ "-", "<cmd>Oil<CR>" },
		{ "<C-->", function() require("oil").toggle_float() end},
    { "|", function () require("oil").open(nil,{preview = {vertical = true}}) end }
	},
	cmd = { "Oil" },
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
}
