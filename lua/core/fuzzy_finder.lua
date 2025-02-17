return {
  "ibhagwan/fzf-lua",
  enable = require("nixCatsUtils").enableForCategory("fuzzy-finder"),
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  opts = {},
  config = function (_, opts)
    require('fzf-lua').setup(opts)

    vim.keymap.set({"n"}, "<leader>pp", require('fzf-lua').git_files )
    vim.keymap.set({"n"}, "<leader>pe", require('fzf-lua').buffers )
    vim.keymap.set({"n"}, "<leader>pl", require('fzf-lua').live_grep )
  end
}
