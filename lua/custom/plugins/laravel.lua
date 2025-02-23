return {
  "adalessa/laravel.nvim",
  enabled = require('nixCatsUtils').enableForCategory("laravel"),
  dependencies = {
    "tpope/vim-dotenv",
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "kevinhwang91/promise-async",
  },
  cmd = { "Laravel"},
  keys = {
  {"<leader>la", ":Laravel artisan<cr>"},
  {"<leader>lr", ":Laravel routes<cr>"},
  {"<leader>lm", ":Laravel related<cr>"},
  },
  event = {"VeryLazy"},
  opts = {
    features = {
      pickers = {
        provider = "fzf-lua"
      }
    }
  },
  config = true,
}
