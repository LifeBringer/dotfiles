-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- mapleader=' ', expandtab, shiftwidth=2, number, relativenumber, ignorecase, smartcase,
-- clipboard=unnamedplus and undofile from the old vim_config.lua are already LazyVim defaults.
local o = vim.opt
o.scrolloff = 16 -- LazyVim default is 4
o.mouse = ''     -- no mouse in nvim; also lets Herdr keep host mouse capture off so Escape isn't swallowed

-- Pin the snacks picker and explorer so a missing or old lazyvim.json can never flip them to fzf/neo-tree.
vim.g.lazyvim_picker = 'snacks'
vim.g.lazyvim_explorer = 'snacks'
