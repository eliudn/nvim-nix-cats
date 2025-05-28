return {
  "tpope/vim-surround",
  "direnv/direnv.vim",
  {
    'stevearc/dressing.nvim',
    opts = {},
    config = function()
      require('dressing').setup({
        input = {
          win_options = {
            winhighlight = 'NormalFloat:DiagnosticError'
          }
        }
      })
    end
  },
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
      -- vim.cmd.colorscheme("evangelion")
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

  -- {
  --
  --   dir = "~/.config/nix_config/cat-nix-vim/lua/themes/eva-darken.lua",
  --   lazy = false,                        -- Asegurar que el tema se cargue siempre
  --   priority = 1000,                     -- Cargar antes que otros temas
  --   config = function()
  --     vim.cmd("colorscheme eva-darken")
  --     -- require("themes.eva-darken").setup() -- Cargar el archivo lua/themes/eva-darken.lua
  --   end,
  -- },
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {},
    config = function()
      require('colorizer').setup()
    end,
  }
}
