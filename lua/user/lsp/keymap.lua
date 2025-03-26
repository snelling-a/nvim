local M = {}

---@param client vim.lsp.Client
---@param bufnr integer
function M.on_attach(client, bufnr)
	local map = require("user.keymap.util").map("Lsp")

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
		if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buftype == "" then
			vim.lsp.inlay_hint.enable(true, { buffer = bufnr })
		end

		map({ "n" }, "<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ buffer = bufnr }))
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
		local next_word_repeat, prev_word_repeat =
			require("nvim-treesitter.textobjects.repeatable_move").make_repeatable_move_pair(words.jump, words.jump)

		map({ "n" }, "]]", function()
			if words.get_is_enabled(bufnr) then
				next_word_repeat(vim.v.count1)
			else
				vim.notify("LspWords is not enabled")
			end
		end, { buffer = bufnr, desc = "Next Reference" })
		map({ "n" }, "[[", function()
			if words.get_is_enabled(bufnr) then
				prev_word_repeat(-vim.v.count1)
			else
				vim.notify("LspWords is not enabled")
			end
		end, { buffer = bufnr, desc = "Prev Reference" })
	end
end

return M
