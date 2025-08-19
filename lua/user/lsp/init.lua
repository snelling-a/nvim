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

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentColor) then
			local ok, hipatterns = pcall(require, "mini.hipatterns")
			if ok then
				hipatterns.disable(event.buf)
			end
			vim.lsp.document_color.enable(true, event.buf)
		end

		require("user.lsp.keymap").on_attach(client, event.buf)
		require("user.lsp.words").on_attach()
		require("user.lsp.overrides").on_attach()
	end,
	group = group,
	desc = "LspAttach",
})
