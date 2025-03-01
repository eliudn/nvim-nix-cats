return {
  "tpope/vim-surround",
  "direnv/direnv.vim",
  {
    "xero/evangelion.nvim",
    lazy = false,
    priority = 1000,
      opts = {
    overrides = {
      keyword = { fg = "#00ff00", bg = "#222222", undercurl = true },
      ["@boolean"] = { link = "Special" },
    },
  },
    init = function()
      vim.cmd.colorscheme("evangelion")
    end,
  },
  -- {
  --   "vague2k/vague.nvim",
  --   opts = {},
  --   lazy = false,
  --   priority = 100,
  --   config = function(_, opts)
  --     require('vague').setup(opts)
  --     vim.cmd.colorscheme('vague')
  --   end,
  -- },
  {
    "norcalli/nvim-colorizer.lua",
    opts = {},
    config = true,
  }
}
