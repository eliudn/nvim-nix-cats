return {

  "folke/snacks.nvim",

  priority = 1000,

  lazy = false,

  keys = {
    -- Top Pickers & Explorer
    { "<leader><space>", function() require('snacks').picker.smart() end, desc = "Smart Find Files" },
    { "<leader>n", function() require('snacks').picker.notifications() end, desc = "Notification History" },
    { "<leader>e", function() require('snacks').explorer() end, desc = "File Explorer" },
    -- -- Grep
    {"<leader>sb", function() require('snacks').picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sh", function() require('snacks').picker.help() end, desc = "Help Pages" },
    { "<leader>sm", function() require('snacks').picker.marks() end, desc = "Marks" },
    { "<leader>su", function() require('snacks').picker.undo() end, desc = "Undo History" },
    -- Other
    { "<leader>z",  function() require('snacks').zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z",  function() require('snacks').zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.",  function() require('snacks').scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() require('snacks').scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>n",  function() require('snacks').notifier.show_history() end, desc = "Notification History" },
    { "<leader>bd", function() require('snacks').bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() require('snacks').rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() require('snacks').gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>gg", function() require('snacks').lazygit() end, desc = "Lazygit" },
    { "<leader>un", function() require('snacks').notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-'>",      function() require('snacks').terminal() end, desc = "Toggle Terminal", mode = {"n", "t"} },
  },

  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },

    dashboard = {
      enabled = true,
    },
    indent = { enabled = true },
    input = { enabled = true }, picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  ---@class snacks.lazygit.Config: snacks.terminal.Opts
  ---@field args? string[]
  ---@field theme? snacks.lazygit.Theme
  lazygit = {
    -- automatically configure lazygit to use the current colorscheme
    -- and integrate edit with the current neovim instance
    configure = true,
    -- extra configuration for lazygit that will be merged with the default
    -- snacks does NOT have a full yaml parser, so if you need `"test"` to appear with the quotes
    -- you need to double quote it: `"\"test\""`
    config = {
      os = { editPreset = "nvim-remote" },
      gui = {
        -- set to an empty string "" to disable icons
        nerdFontsVersion = "3",
      },
    },
    -- theme_path = svim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
    -- Theme for lazygit
    theme = {
      [241]                      = { fg = "Special" },
      activeBorderColor          = { fg = "MatchParen", bold = true },
      cherryPickedCommitBgColor  = { fg = "Identifier" },
      cherryPickedCommitFgColor  = { fg = "Function" },
      defaultFgColor             = { fg = "Normal" },
      inactiveBorderColor        = { fg = "FloatBorder" },
      optionsTextColor           = { fg = "Function" },
      searchingActiveBorderColor = { fg = "MatchParen", bold = true },
      selectedLineBgColor        = { bg = "Visual" }, -- set to `default` to have no background colour
      unstagedChangesColor       = { fg = "DiagnosticError" },
    },
    win = {
      style = "lazygit",
    },
  }
}
