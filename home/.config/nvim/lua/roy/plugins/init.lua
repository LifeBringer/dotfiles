-- Plugin list adapted from craftzdog/dotfiles-public. Differences: rose-pine instead of solarized-osaka,
-- upstream mini.diff instead of craftzdog's fork, and Roy's additions marked below.
local gh = function(x)
	return "https://github.com/" .. x
end

-- Build tree-sitter parsers after nvim-treesitter is installed or updated. Registered before
-- vim.pack.add so it also fires on the very first install.
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	-- UI
	{ src = gh("rose-pine/neovim"), name = "rose-pine" },
	{ src = gh("nvim-mini/mini.icons") },
	{ src = gh("folke/snacks.nvim") },
	{ src = gh("folke/trouble.nvim") },
	{ src = gh("nvim-lualine/lualine.nvim") },
	{ src = gh("b0o/incline.nvim") },
	{ src = gh("esmuellert/codediff.nvim") },
	{ src = gh("rachartier/tiny-cmdline.nvim") },
	{ src = gh("folke/which-key.nvim") }, -- Roy
	-- Editor
	{ src = gh("stevearc/conform.nvim") },
	{ src = gh("nvim-treesitter/nvim-treesitter") },
	{ src = gh("mks-h/treesitter-autoinstall.nvim") },
	{ src = gh("nvim-mini/mini.pairs") },
	{ src = gh("nvim-mini/mini.diff") },
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("^1") },
	{ src = gh("folke/todo-comments.nvim") },
	{ src = gh("lewis6991/gitsigns.nvim") },
	{ src = gh("linrongbin16/gitlinker.nvim") },
	{ src = gh("brenoprata10/nvim-highlight-colors") },
	{ src = gh("MeanderingProgrammer/render-markdown.nvim") }, -- Roy
	-- Git (Roy)
	{ src = gh("nvim-lua/plenary.nvim") },
	{ src = gh("sindrets/diffview.nvim") },
	{ src = gh("NeogitOrg/neogit") },
	-- LSP
	{ src = gh("neovim/nvim-lspconfig") },
	{ src = gh("mason-org/mason.nvim") },
	{ src = gh("WhoIsSethDaniel/mason-tool-installer.nvim") },
	{ src = gh("b0o/SchemaStore.nvim") }, -- Roy
	-- Util
	{ src = gh("stevearc/oil.nvim") },
	{ src = gh("zbirenbaum/copilot.lua") },
}, { confirm = false })

if #vim.api.nvim_get_runtime_file("lua/roy/plugins/local.lua", false) > 0 then
	require("roy.plugins.local")
end

require("roy.plugins.ui")
require("roy.plugins.treesitter")
require("roy.plugins.editor")
require("roy.plugins.lsp")
require("roy.plugins.util")
require("roy.plugins.git")
require("roy.plugins.keymaps")
