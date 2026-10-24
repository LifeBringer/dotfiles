return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- nil comes from nixpkgs (home.nix). mason's package compiles it with cargo,
        -- which is not installed, so keep mason away from this one server.
        nil_ls = { mason = false },
      },
    },
  },
}
