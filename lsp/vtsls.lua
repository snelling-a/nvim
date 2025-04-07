local action_table = setmetatable({}, {
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

local inlay_hints = {
	enumMemberValues = { enabled = true },
	functionLikeReturnTypes = { enabled = true },
	parameterNames = { enabled = "literals" },
	parameterTypes = { enabled = true },
	propertyDeclarationTypes = { enabled = true },
	variableTypes = { enabled = false },
}

local settings = {
	updateImportsOnFileMove = { enabled = "always" },
	suggest = { completeFunctionCalls = true },
	inlayHints = inlay_hints,
}

---@type vim.lsp.Config
return {
	cmd = { "vtsls", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
	settings = {
		complete_function_calls = true,
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			experimental = {
				maxInlayHintLength = 30,
				completion = { enableServerSideFuzzyMatch = true },
			},
		},
		typescript = settings,
		javascript = settings,
	},
	single_file_support = true,
	on_attach = function(_client, bufnr)
		local map = require("user.keymap.util").map("Vtsls")

		map(
			{ "n" },
			"<leader>co",
			action_table["source.organizeImports"],
			{ buffer = bufnr, desc = "[O]rganize Imports" }
		)
		map(
			{ "n" },
			"<leader>cM",
			action_table["source.addMissingImports.ts"],
			{ buffer = bufnr, desc = "Add [M]issing Imports" }
		)
		map(
			{ "n" },
			"<leader>cD",
			action_table["source.removeUnused.ts"],
			{ buffer = bufnr, desc = "Remove Unused Imports" }
		)
		map({ "n" }, "<leader>F", action_table["source.fixAll.ts"], { buffer = bufnr, desc = "[F]ix All Diagnostics" })
	end,
}
