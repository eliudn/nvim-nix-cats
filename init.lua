require("nixCatsUtils").setup({
  non_nix_value = true,
})

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.mouse = "";
vim.o.expandtab = true;
vim.o.tabstop = 4;
vim.o.softtabstop = 4;
vim.o.shiftwidth = 4;
vim.o.smartindent = true;
vim.o.errorbells = false;
vim.o.wrap = false;
vim.o.swapfile = false;
vim.o.undofile = true;
vim.o.hlsearch = false;
vim.o.incsearch = true;
vim.o.ignorecase = true;
vim.o.smartcase = true;
vim.o.colorcolumn = "80";
vim.o.termguicolors = true;
vim.o.sidescrolloff = 4;
vim.o.showmode = false;
vim.o.clipboard = "unnamedplus";

-- NOTE: nixCats: You might want to move the lazy-lock.json file
local function getlockfilepath()
  if require("nixCatsUtils").isNixCats and type(nixCats.settings.unwrappedCfgPath) == "string" then
    return nixCats.settings.unwrappedCfgPath .. "/lazy-lock.json"
  else
    return vim.fn.stdpath("config") .. "/lazy-lock.json"
  end
end
local lazyOptions = {
  lockfile = getlockfilepath(),
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
}
require("nixCatsUtils.lazyCat").setup(nixCats.pawsible({ "allPlugins", "start", "lazy.nvim" }), {
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  require("core.lsp"),
  require("core.treesitter"),
  require("core.file_manager"),
  require("core.fuzzy_finder"),
  require("core.completacion"),

  { import = "custom.plugins" },
}, lazyOptions)
