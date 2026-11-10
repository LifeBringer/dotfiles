-- Adapted from craftzdog/dotfiles-public, plus Roy's (kunchen-era) keys at the bottom.
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without updating the registers
keymap.set("n", "x", '"_x', { desc = "Delete char without yank" })
keymap.set("n", "<Leader>p", '"0p', { desc = "Paste last yank" })
keymap.set("n", "<Leader>P", '"0P', { desc = "Paste last yank before" })
keymap.set("v", "<Leader>p", '"0p', { desc = "Paste last yank" })
keymap.set("n", "<Leader>c", '"_c', { desc = "Change without yank" })
keymap.set("n", "<Leader>C", '"_C', { desc = "Change to EOL without yank" })
keymap.set("v", "<Leader>c", '"_c', { desc = "Change without yank" })
keymap.set("v", "<Leader>C", '"_C', { desc = "Change lines without yank" })
keymap.set("n", "<Leader>d", '"_d', { desc = "Delete without yank" })
keymap.set("n", "<Leader>D", '"_D', { desc = "Delete to EOL without yank" })
keymap.set("v", "<Leader>d", '"_d', { desc = "Delete without yank" })
keymap.set("v", "<Leader>D", '"_D', { desc = "Delete lines without yank" })

-- Increment/decrement
keymap.set("n", "+", "<C-a>", { desc = "Increment" })
keymap.set("n", "-", "<C-x>", { desc = "Decrement" })

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d', { desc = "Delete word backwards" })

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", vim.tbl_extend("force", opts, { desc = "Open line below without comment" }))
keymap.set("n", "<Leader>O", "O<Esc>^Da", vim.tbl_extend("force", opts, { desc = "Open line above without comment" }))

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", vim.tbl_extend("force", opts, { desc = "Jump forward" }))

-- New tab
keymap.set("n", "te", ":tabedit<CR>", { desc = "New tab" })
keymap.set("n", "<tab>", ":tabnext<CR>", vim.tbl_extend("force", opts, { desc = "Next tab" }))
keymap.set("n", "<s-tab>", ":tabprev<CR>", vim.tbl_extend("force", opts, { desc = "Previous tab" }))
-- Split window
keymap.set("n", "ss", ":split<Return>", vim.tbl_extend("force", opts, { desc = "Split below" }))
keymap.set("n", "sv", ":vsplit<Return>", vim.tbl_extend("force", opts, { desc = "Split right" }))
-- Move window
keymap.set("n", "sh", "<C-w>h", { desc = "Window left" })
keymap.set("n", "sk", "<C-w>k", { desc = "Window up" })
keymap.set("n", "sj", "<C-w>j", { desc = "Window down" })
keymap.set("n", "sl", "<C-w>l", { desc = "Window right" })

-- Toggle inlay hints
keymap.set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle inlay hints" })

-- Yank current file path
keymap.set("n", "<leader>yf", function()
	require("roy.utils.editor").yank_relative_path_with_line()
end, { desc = "Yank relative path with line number" })

keymap.set("n", "<leader>yp", function()
	require("roy.utils.editor").yank_absolute_path_with_line()
end, { desc = "Yank absolute path with line number" })

keymap.set(
	"v",
	"<leader>cc",
	":<C-u>lua require('roy.utils.editor').copy_as_codeblock()<CR>",
	{ desc = "Copy as Markdown code block" }
)

keymap.set("n", "<leader>j", function()
	require("roy.utils.editor").open_package_json()
end, { desc = "Open package.json in floating window" })

keymap.set("n", "<leader>bd", function()
	require("roy.utils.editor").delete_hidden_buffers()
end, { desc = "Delete hidden buffers" })

-- Restart Neovim in place (built-in :restart, Neovim 0.12)
keymap.set("n", "ZR", "<cmd>restart<cr>", { desc = "Restart Neovim" })

-- Roy: save by pressing Escape. Clears search highlight, and only writes real file buffers so Esc
-- stays quiet in pickers, Neogit, Oil, help and scratch buffers.
keymap.set("n", "<Esc>", function()
	vim.cmd("noh")
	if vim.bo.buftype == "" and vim.bo.modifiable and vim.api.nvim_buf_get_name(0) ~= "" then
		vim.cmd("update") -- update, not write: never clobbers an agent's on-disk edit to an unmodified buffer
	end
end, { desc = "Save" })

-- Roy: pasting over a selection keeps the register
vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]])
