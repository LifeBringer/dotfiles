-- Adapted from craftzdog/dotfiles-public. Roy's additions: Go, Python, Nix, JSON and Markdown servers.
-- tree-sitter CLI, nil and nixfmt come from nixpkgs (home.nix), not mason.
require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua-language-server",
		"prettier",
		"prettierd",
		"selene",
		"shellcheck",
		"shfmt",
		"stylua",
		"eslint-lsp",
		"oxlint",
		"oxfmt",
		"tailwindcss-language-server",
		"vtsls",
		"css-lsp", -- craftzdog enables cssls but does not install it
		"glsl_analyzer", -- same for glsl_analyzer
		"copilot-language-server",
		"rust-analyzer",
		-- Roy
		"gopls",
		"gofumpt",
		"goimports",
		"pyright",
		"ruff",
		"json-lsp",
		"marksman",
	},
	auto_update = false,
	run_on_start = true,
})

local capabilities = {
	workspace = {
		fileOperations = {
			didRename = true,
			willRename = true,
		},
	},
}
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(capabilities),
})

vim.lsp.enable({
	"eslint",
	"oxlint",
	"lua_ls",
	"cssls",
	"vtsls",
	"tailwindcss",
	"glsl_analyzer",
	"rust_analyzer",
	-- Roy
	"gopls",
	"pyright",
	"ruff",
	"nil_ls",
	"jsonls",
	"marksman",
})
