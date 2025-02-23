return {
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", enabled = require("nixCatsUtils").lazyAdd(true, false), config = true },
    { "williamboman/mason-lspconfig.nvim", enabled = require("nixCatsUtils").lazyAdd(true, false), },
    { "WhoIsSethDaniel/mason-tool-installer.nvim", enabled = require("nixCatsUtils").lazyAdd(true, false), },
    { "j-hui/fidget.nvim",       opts = {} },

    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          -- adds type hints for nixCats global
          { path = (nixCats.nixCatsPath or "") .. "/lua", words = { "nixCats" } },
        },
      },
    },
  },

  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")
        map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")
        map("gI", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementacion")
        map("<leader>D", require("fzf-lua").lsp_typedefs, "Type [D]efinition")
        map("<leader>ds", require("fzf-lua").lsp_document_symbols, "[D]ocument [S]ymbols")
        map("<leader>ws", require("fzf-lua").lsp_live_workspace_symbols, "[W]orksapce [S]ymbols")
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
            end,
          })
        end

        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "[T]oggle Inlay [H]ints")
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
    local servers = {}
    if require("nixCatsUtils").isNixCats then
      servers.nixd = {}
    else
      servers.rnix = {}
      servers.nil_ls = {}
    end
    servers.lua_ls = {
      -- cmd = {...},
      -- filetypes = { ...},
      -- capabilities = {},
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          diagnostics = {
            globals = { "nixCats" },
            disable = { "missing-fields" },
          },
        },
      },
    }

    servers.phpactor = {
      filetypes = {"php", "blade"},
      init_options = {
        ["language_server_worse_reflection.inlay_hints.enable"]=true,
        ["language_server_worse_reflection.inlay_hints.types"]=false,
        ["language_server_worse_reflection.inlay_hints.params"]=true,
        ["code_transform.import_globals"]= true,
      },
      handlers = {
        ["textDocument/inlayHint"] = function (err, result, ...)
          for _, res in ipairs(result) do
            res.label = res.label .. ": "
          end
          vim.lsp.handlers["textDocument/inlayHint"](err, result, ...)
        end,
      }
    }

    if require("nixCatsUtils").isNixCats then
      for server_name, _ in pairs(servers) do
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          settings = (servers[server_name] or {}).settings,
          init_options =(servers[server_name] or {}).init_options,
          handlers =(servers[server_name] or {}).handlers,
          filetypes = (servers[server_name] or {}).filetypes,
          cmd = (servers[server_name] or {}).cmd,
          root_pattern = (servers[server_name] or {}).root_pattern,
        })
      end
    else
      --  You can press `g?` for help in this menu.
      require("mason").setup()

      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end
  end,
}
