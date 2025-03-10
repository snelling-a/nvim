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
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
		},
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = {
				completeFunctionCalls = true,
			},
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = false },
			},
		},
	},
	single_file_support = true,
	on_init = function(client, _initialize_result)
		client.commands["_typescript.moveToFileRefactoring"] = function(command, _ctx)
			---@type string, string, lsp.Range
			local action, uri, range = unpack(command.arguments) ---@diagnostic disable-line: assign-type-mismatch

			local function move(newf)
				client:request("workspace/executeCommand", {
					command = command.command,
					arguments = { action, uri, range, newf },
				})
			end

			local fname = vim.uri_to_fname(uri)
			client:request("workspace/executeCommand", {
				command = "typescript.tsserverRequest",
				arguments = {
					"getMoveToRefactoringFileSuggestions",
					{
						file = fname,
						startLine = range.start.line + 1,
						startOffset = range.start.character + 1,
						endLine = range["end"].line + 1,
						endOffset = range["end"].character + 1,
					},
				},
			}, function(_, result)
				---@type string[]
				local files = result.body.files
				table.insert(files, 1, "Enter new path...")
				vim.ui.select(files, {
					prompt = "Select move destination:",
					format_item = function(f)
						return vim.fn.fnamemodify(f, ":~:.")
					end,
				}, function(f)
					if f and f:find("^Enter new path") then
						vim.ui.input({
							prompt = "Enter move destination:",
							default = vim.fn.fnamemodify(fname, ":h") .. "/",
							completion = "file",
						}, function(newf)
							return newf and move(newf)
						end)
					elseif f then
						move(f)
					end
				end)
			end)
		end

		client.settings.javascript =
			vim.tbl_deep_extend("force", {}, client.settings.typescript, client.settings.javascript or {})
	end,
	on_attach = function(_client, bufnr)
		local map = require("user.keymap.util").map("Vtsls")

		map("n", "<leader>co", action_table["source.organizeImports"], { buffer = bufnr, desc = "[O]rganize Imports" })
		map(
			"n",
			"<leader>cM",
			action_table["source.addMissingImports.ts"],
			{ buffer = bufnr, desc = "Add [M]issing Imports" }
		)
		map(
			"n",
			"<leader>cD",
			action_table["source.removeUnused.ts"],
			{ buffer = bufnr, desc = "Remove Unused Imports" }
		)
		map("n", "<leader>F", action_table["source.fixAll.ts"], { buffer = bufnr, desc = "[F]ix All Diagnostics" })
	end,
}
