return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		enabled = require("nixCatsUtils").enableForCategory("file-manager"),
		keys = {
			{ "-",     "<cmd>Oil<CR>" },
			{ "<C-->", function() require("oil").toggle_float() end },
		},
		cmd = { "Oil" },
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		config = function()
			require("oil").setup({
				win_options = {
					signcolumn = "yes:2",
				},
			})
		end
	}
}
