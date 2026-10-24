return {
  -- Parsers snacks.image needs to render images embedded in these document types
  -- (latex also drives LaTeX math rendering). :checkhealth snacks warns about any that
  -- are missing; LazyVim's own ensure_installed covers the rest and the lists merge.
  -- norg is left out on purpose: nvim-treesitter (main) no longer supports it, so the
  -- one remaining snacks warning about norg is expected.
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'css', 'latex', 'scss', 'svelte', 'typst', 'vue' } },
  },
}
