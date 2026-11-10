-- Roy: ruff owns import organizing; pyright keeps type checking
---@type vim.lsp.Config
return {
  settings = {
    pyright = { disableOrganizeImports = true },
  },
}
