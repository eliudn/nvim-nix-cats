local function get_typescript_server_path(root_dir)
  local project_root = vim.fs.dirname(vim.fs.find('node_modules', { path = root_dir, upward = true })[1])
  return project_root and (project_root .. '/node_modules/typescript/lib') or ''
end
---@type vim.lsp.Config
return {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  root_markers = { 'package.json' },
  init_options = {
    typescript = {
      tsdk = ''
    },

  },
  on_new_config = function(new_config, new_root_dir)
    if
        new_config.init_options
        and new_config.init_options.typescript
        and new_config.init_options.typescript.tsdk == ''
    then
      new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
    end
  end,

}
