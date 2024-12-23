---@class user.Lsp.keymap
local M = {}

local action = setmetatable({}, {
	---@param action lsp.CodeActionKind Actions not of this kind are filtered out by the client before being shown
	---@return function
	__index = function(_, action)
		return function()
			vim.lsp.buf.code_action({
				apply = true,
				context = {
					only = { action },
					diagnostics = {},
				},
			})
		end
	end,
})

---@type OnAttach<nil>
function M.on_attach(client, bufnr)
	local map = Config.keymap("Lsp")

	if Config.lsp.client_supports_method(bufnr, vim.lsp.protocol.Methods.textDocument_inlayHint) then
		map("n", "<leader>th", function()
			Config.keymap.toggle.inlay_hints()
		end, { desc = "[t]oggle inlay [h]ints" })
	end

	if Config.lsp.client_supports_method(bufnr, vim.lsp.protocol.Methods.textDocument_declaration) then
		map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "[G]oto [D]eclaration" })
	end

	if Config.lsp.client_supports_method(bufnr, vim.lsp.protocol.Methods.textDocument_definition) then
		map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "[G]oto [D]efinition" })
	end

	if Config.lsp.client_supports_method(bufnr, vim.lsp.protocol.Methods.textDocument_documentHighlight) then
		map("n", "]]", function()
			Config.lsp.words.jump(vim.v.count1)
		end, { buffer = bufnr, desc = "Next Reference" })
		map("n", "[[", function()
			Config.lsp.words.jump(-vim.v.count1)
		end, { buffer = bufnr, desc = "Prev Reference" })
	end

	if client.name == "ts_ls" then
		map("n", "<leader>co", action["source.organizeImports"], { buffer = bufnr, desc = "[O]rganize Imports" })
		map(
			"n",
			"<leader>cM",
			action["source.addMissingImports.ts"],
			{ buffer = bufnr, desc = "Add [M]issing Imports" }
		)
		map("n", "<leader>cD", action["source.removeUnused.ts"], { buffer = bufnr, desc = "Remove Unused Imports" })
		map("n", "<leader>F", action["source.fixAll.ts"], { buffer = bufnr, desc = "[F]ix All Diagnostics" })
	end
end

return M
