return {
    'windwp/nvim-autopairs',
    enable = require("nixCatsUtils").enableForCategory("nvim-autopairs"),
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
}
