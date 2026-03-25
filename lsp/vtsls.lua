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
		"typescript",
		"typescriptreact",
	},
	root_dir = function(bufnr, on_dir)
		local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
		root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
			or vim.list_extend(root_markers, { ".git" })
		-- exclude deno
		local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
		local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
		local project_root = vim.fs.root(bufnr, root_markers)
		if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
			return
		end
		if deno_root and (not project_root or #deno_root >= #project_root) then
			return
		end
		on_dir(project_root or vim.fn.getcwd())
	end,
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
		vim.keymap.set(
			{ "n" },
			"<leader>co",
			action_table["source.organizeImports"],
			{ buffer = bufnr, desc = "[O]rganize Imports" }
		)
		vim.keymap.set(
			{ "n" },
			"<leader>cM",
			action_table["source.addMissingImports.ts"],
			{ buffer = bufnr, desc = "Add [M]issing Imports" }
		)
		vim.keymap.set(
			{ "n" },
			"<leader>cD",
			action_table["source.removeUnused.ts"],
			{ buffer = bufnr, desc = "Remove Unused Imports" }
		)
		vim.keymap.set(
			{ "n" },
			"<leader>F",
			action_table["source.fixAll.ts"],
			{ buffer = bufnr, desc = "[F]ix All Diagnostics" }
		)
	end,
	init_options = {
		hostInfo = "neovim",
	},
}
