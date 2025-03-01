return {
  "tpope/vim-surround",
  "direnv/direnv.vim",
  {
    "vague2k/vague.nvim",
    opts = {},
    lazy = false,
    priority = 100,
    config = function(_, opts)
      require('vague').setup(opts)
      vim.cmd.colorscheme('vague')
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    opts = {},
    config = true,
  }
}
