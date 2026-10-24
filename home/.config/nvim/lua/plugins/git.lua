return {
  -- Neogit + diffview kept from the old config. Moved from <leader>g (now LazyVim's git group,
  -- lazygit on <leader>gg) to <leader>gn, which no LazyVim keymap or extra uses.
  {
    'NeogitOrg/neogit',
    dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
    cmd = 'Neogit',
    keys = { { '<leader>gn', function() require('neogit').open() end, desc = 'Neogit' } },
  },
  -- gitsigns is LazyVim core; opts are merged, so only the delta is listed
  { 'lewis6991/gitsigns.nvim', opts = { current_line_blame = true } },
}
