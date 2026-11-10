-- Roy (kunchen): Neogit with diffview, next to craftzdog's lazygit + codediff + mini.diff stack.
require("neogit").setup({
	integrations = { diffview = true, snacks = true },
})
