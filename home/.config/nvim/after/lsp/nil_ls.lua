-- Roy: nil comes from nixpkgs; let it format with nixfmt too
---@type vim.lsp.Config
return {
  settings = {
    ["nil"] = {
      formatting = { command = { "nixfmt" } },
    },
  },
}
