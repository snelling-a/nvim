if vim.g.vscode then
	return
end

vim.lsp.config("*", {
	capabilities = {
		workspace = {
			fileOperations = { didRename = true, willRename = true },
		},
		textDocument = {
			semanticTokens = { multilineTokenSupport = true },
		},
	},
	root_markers = { ".git" },
})

local servers = require("user.lsp.util").get_all_client_names()
for _, server_name in ipairs(servers) do
	vim.lsp.enable(server_name)
end

local group = require("user.autocmd").augroup("lsp")
vim.api.nvim_create_autocmd({ "LspAttach" }, {
	callback = function(event)
		local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

		require("user.lsp.keymap").on_attach(client, event.buf)
		require("user.lsp.words").on_attach()
		require("user.lsp.overrides").on_attach()
	end,
	group = group,
	desc = "LspAttatch",
})
