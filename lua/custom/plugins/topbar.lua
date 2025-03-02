local M = {}
M.breadcrumbs = {
    "LunarVim/breadcrumbs.nvim",
    dependencies = {
        { "SmiteshP/nvim-navic" },
    },
}
M.navic = {
    "SmiteshP/nvim-navic",
    opst = {},
    config = function()
        require("nvim-navic")
    end
}
function M.breadcrumbs.config()
    require("nvim-navic").setup {
        lsp = {
            auto_attach = true,
        },
    }

    require("breadcrumbs").setup()
end

M.winbar = {
    "fgheng/winbar.nvim",
    opts = {},
    config = function()
        require('winbar')
    end
}

M.drobar = {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    -- dependencies = {
    --     'nvim-telescope/telescope-fzf-native.nvim',
    --     build = 'make'
    -- },
    config = function()
        local dropbar_api = require('dropbar.api')
        vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
        vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
        vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end
}
return M.drobar
