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
vim.lsp.enable(servers)

local group = require("user.autocmd").augroup("lsp")

vim.api.nvim_create_autocmd({ "LspAttach" }, {
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentColor) then
			local okay, hipatterns = pcall(require, "mini.hipatterns")
			if okay then
				hipatterns.disable(args.buf)
			end
			vim.lsp.document_color.enable(true, args.buf)
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			local inlay_hints_group = require("user.autocmd").augroup("lsp.inlay_hints")

			if vim.g.inlay_hints then
				vim.defer_fn(function()
					local mode = vim.api.nvim_get_mode().mode
					vim.lsp.inlay_hint.enable(mode == "n" or mode == "v", { bufnr = args.buf })
				end, 500)
			end

			vim.api.nvim_create_autocmd({ "InsertEnter" }, {
				buffer = args.buf,
				callback = function()
					if vim.g.inlay_hints then
						vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
					end
				end,
				desc = "Enable inlay hints",
				group = inlay_hints_group,
			})

			vim.api.nvim_create_autocmd({ "InsertLeave" }, {
				buffer = args.buf,
				callback = function()
					if vim.g.inlay_hints then
						vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
					end
				end,
				desc = "Disable inlay hints",
				group = inlay_hints_group,
			})
		end

		require("user.lsp.command")
		require("user.lsp.keymap").on_attach(client, args.buf)
		require("user.lsp.words").on_attach()
		require("user.lsp.overrides").on_attach()
	end,
	group = group,
	desc = "LspAttach",
})
