-- Structure and most modules adapted from craftzdog/dotfiles-public (dot_config/nvim), reconciled with
-- Roy's earlier kunchenguid-based config. Plugins are managed by Neovim's built-in vim.pack.
if vim.loader then
  vim.loader.enable()
end

_G.Roy = require("roy.utils")
require("roy.config.options")
require("roy.config.keymaps")
require("roy.config.autocmds")
require("roy.config.commands")
require("roy.config.workarounds")
require("roy.plugins")
