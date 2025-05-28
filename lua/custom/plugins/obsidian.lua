local vaults = {
    {
        name = "personal",
        path = "~/leunamz_obsidian/personal",
    },
    {
        name = "work",
        path = "~/leunamz_obsidian/work",
    },
}

local events = vim
  .iter(vaults)
  :map(function(vault)
    return vim.fn.expand(vault.path)
  end)
  :map(function(vault)
    return {
      string.format("BufReadPre %s/*.md", vault),
      string.format("BufNewFile %s/*.md", vault),
    }
  end)
  :flatten()
  :totable()
-- local events = {}
-- for _, vault in ipairs(vaults) do
--     table.insert(events, string.format("BufReadPre %s/*.md", vim.fn.expand(vault.path)))
--     table.insert(events, string.format("BufNewFile %s/*.md", vim.fn.expand(vault.path)))
-- end
return {
    "epwalsh/obsidian.nvim",
    enabled = require('nixCatsUtils').enableForCategory("obsidian"),
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    -- ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = events,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cmd = {"ObsidianMenu", "ObsidianNew"},
    opts = {
        workspaces = vaults,
    },
    keys = {
        {"<leader>ob", "<cmd> ObsidianMenu<cr>"},
    },
    mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
            action = function()
                return require("obsidian").util.gf_passthrough()
            end,
            opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
            action = function()
                return require("obsidian").util.toggle_checkbox()
            end,
            opts = { buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ["<cr>"] = {
            action = function()
                return require("obsidian").util.smart_action()
            end,
            opts = { buffer = true, expr = true },
        }
    },
    config = function(_, opts)
        require("obsidian").setup(opts)

        local actions = {
            Search = "ObsidianSearch",
            Today = "ObsidianToday",
            Yesterday = "ObsidianYesterday",
            Tomorrow = "ObsidianTomorrow",
            new = "ObsidianNew",
        }

        vim.api.nvim_create_user_command("ObsidianMenu", function()
            vim.ui.select(vim.tbl_keys(actions), { prompt = "Obsidian Action" }, function(selected)
                vim.cmd(actions[selected])
            end)
        end, {})
    end,
}
