local M = {}

---@param client vim.lsp.Client
---@param bufnr integer
function M.on_attach(client, bufnr)
	local map = require("user.keymap.util").map("Lsp")

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
		map({ "n" }, "<leader>th", function()
			vim.g.inlay_hints = not vim.g.inlay_hints

			local mode = vim.api.nvim_get_mode().mode
			vim.lsp.inlay_hint.enable(vim.g.inlay_hints and (mode == "n" or mode == "v"))
		end, { desc = "[T]oggle Inlay [H]ints" })
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_declaration, bufnr) then
		map({ "n" }, "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "[G]oto [D]eclaration" })
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_definition, bufnr) then
		map({ "n" }, "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "[G]oto [D]efinition" })
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
		local words = require("user.lsp.words")

		map({ "n" }, "]]", function()
			if words.get_is_enabled(bufnr) then
				words.jump(vim.v.count1)
			else
				vim.notify("LspWords is not enabled")
			end
		end, { buffer = bufnr, desc = "Next Reference" })
		map({ "n" }, "[[", function()
			if words.get_is_enabled(bufnr) then
				words.jump(-vim.v.count1)
			else
				vim.notify("LspWords is not enabled")
			end
		end, { buffer = bufnr, desc = "Prev Reference" })
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentColor) then
		map({ "n", "x" }, "grc", function()
			vim.lsp.document_color.color_presentation()
		end, { desc = "vim.lsp.document_color.color_presentation()" })
	end
end

return M
