return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = true, -- loaded by LazyVim's colorscheme step, same pattern as its built-in tokyonight spec
    opts = {
      dark_variant = 'moon',
      dim_inactive_windows = false,
      extend_background_behind_borders = false,
      styles = {
        italic = false,
        -- transparent background on macOS, Windows and WSL terminals
        transparency = vim.uv.os_uname().sysname == 'Darwin'
          or string.find(vim.uv.os_uname().sysname, 'Windows') ~= nil
          or string.find(vim.uv.os_uname().release, 'WSL') ~= nil,
      },
      -- make the dimmed dir path in the Snacks picker readable
      highlight_groups = {
        SnacksPickerDir = { fg = 'subtle' },
      },
    },
  },
  { 'LazyVim/LazyVim', opts = { colorscheme = 'rose-pine' } },
}
