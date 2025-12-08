---@type vim.lsp.Config
return {
	before_init = function(_, config)
		local root_dir = config.root_dir
		if root_dir then
			config.settings = config.settings or {}
			config.settings.workspaceFolder = { uri = root_dir, name = vim.fn.fnamemodify(root_dir, ":t") }
			local flat_config_files = {
				"eslint.config.cjs",
				"eslint.config.cts",
				"eslint.config.js",
				"eslint.config.mjs",
				"eslint.config.mts",
				"eslint.config.ts",
			}
			for _, file in ipairs(flat_config_files) do
				if vim.fn.filereadable(root_dir .. "/" .. file) == 1 then
					config.settings.experimental = config.settings.experimental or {}
					config.settings.experimental.useFlatConfig = true
					break
				end
			end
		end
	end,
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = {
		"astro",
		"javascript",
		"javascript.jsx",
		"javascriptreact",
		"svelte",
		"typescript",
		"typescript.tsx",
		"typescriptreact",
		"vue",
	},
	handlers = {
		["eslint/confirmESLintExecution"] = function(_, result)
			if not result then
				return
			end
			return 4
		end,
		["eslint/noLibrary"] = function()
			vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
			return {}
		end,
		["eslint/openDoc"] = function(_, result)
			if result then
				vim.ui.open(result.url)
			end
			return {}
		end,
		["eslint/probeFailed"] = function()
			vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
			return {}
		end,
	},
	on_attach = function(client)
		vim.api.nvim_buf_create_user_command(0, "LspEslintFixAll", function()
			local bufnr = vim.api.nvim_get_current_buf()
			client:exec_cmd({
				title = "Fix all Eslint errors for current buffer",
				command = "eslint.applyAllFixes",
				arguments = {
					{ uri = vim.uri_from_bufnr(bufnr), version = vim.lsp.util.buf_versions[bufnr] },
				},
			}, { bufnr = bufnr })
		end, {})
	end,
	root_markers = {
		".eslintrc",
		".eslintrc.cjs",
		".eslintrc.js",
		".eslintrc.json",
		".eslintrc.yaml",
		".eslintrc.yml",
		"eslint.config.cjs",
		"eslint.config.cts",
		"eslint.config.js",
		"eslint.config.mjs",
		"eslint.config.mts",
		"eslint.config.ts",
	},
	settings = {
		codeAction = {
			disableRuleComment = { enable = true, location = "separateLine" },
			showDocumentation = { enable = true },
		},
		codeActionOnSave = { enable = false, mode = "all" },
		experimental = { useFlatConfig = false },
		format = false,
		nodePath = "",
		onIgnoredFiles = "off",
		packageManager = nil,
		problems = { shortenToSingleLine = false },
		quiet = false,
		rulesCustomizations = {},
		run = "onType",
		useESLintClass = true,
		validate = "on",
		workingDirectory = { mode = "location" },
	},
	workspace_required = true,
}
