return {
  -- Oil on <leader>e, overriding LazyVim's snacks explorer there. <leader>E, <leader>fe and
  -- <leader>fE still open the snacks explorer.
  {
    'stevearc/oil.nvim',
    lazy = false, -- oil's README: lazy-loading breaks `nvim .` and `:e dir/` handling
    opts = { view_options = { show_hidden = true } },
    keys = { { '<leader>e', '<cmd>Oil<cr>', desc = 'File Browser (Oil)' } },
  },
  {
    'folke/snacks.nvim',
    -- picker, notifier, input and explorer are LazyVim defaults, so the old snacks spec is gone.
    -- Take <leader>e away from the explorer and let Oil own directory buffers.
    opts = { explorer = { replace_netrw = false } },
    keys = { { '<leader>e', false } },
  },
}
