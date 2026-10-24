-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Save by pressing Escape. LazyVim maps <esc> (n/i/s) to clear hlsearch; this override keeps that in
-- normal mode and adds the write. Only real file buffers are written so Esc stays quiet in the
-- dashboard, pickers, Neogit and Oil. (Drop the `if` for the old unconditional `:w`.)
vim.keymap.set('n', '<Esc>', function()
  vim.cmd('noh')
  if vim.bo.buftype == '' and vim.api.nvim_buf_get_name(0) ~= '' then
    vim.cmd('write')
  end
end, { desc = 'Save' })

vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select All' }) -- LazyVim core leaves <C-a> alone

vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]]) -- pasting over a selection keeps the register
