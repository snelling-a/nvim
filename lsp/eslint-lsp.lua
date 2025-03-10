local function get_node_path()
	local result = vim.fn.system("which node")

	result = result:gsub("\r\n$", ""):gsub("\n$", "")

	if vim.v.shell_error ~= 0 then
		vim.notify("Error: Could not find Node.js path.")
		return nil
	end

	return result
end

local function get_workspace_folder(bufnr)
	local git_dir = vim.fs.root(bufnr, { ".git" }) or ""
	return { uri = vim.uri_from_fname(git_dir), name = vim.fn.fnamemodify(git_dir, ":t") }
end

---@type vim.lsp.Config
return {
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
		["eslint/openDoc"] = function(_, result)
			if not result then
				return
			end
			local sysname = vim.uv.os_uname().sysname
			if sysname:match("Windows") then
				os.execute(string.format("start %q", result.url))
			elseif sysname:match("Linux") then
				os.execute(string.format("xdg-open %q", result.url))
			else
				os.execute(string.format("open %q", result.url))
			end
			return {}
		end,
		["eslint/confirmESLintExecution"] = function(_, result)
			if not result then
				return
			end
			return 4
		end,
		["eslint/probeFailed"] = function()
			vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
			return {}
		end,
		["eslint/noLibrary"] = function()
			vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
			return {}
		end,
		---@param params lsp.ConfigurationParams
		---@param ctx lsp.HandlerContext
		---@return table|nil
		[vim.lsp.protocol.Methods.workspace_configuration] = function(_, params, ctx)
			if not params.items then
				return {}
			end

			---@param settings table
			---@param section string
			---@return any
			local function lookup_section(settings, section)
				local keys = vim.split(section, ".", { plain = true }) --- @type string[]
				return vim.tbl_get(settings, unpack(keys))
			end

			local client_id = ctx.client_id
			local client = vim.lsp.get_client_by_id(client_id)
			if not client then
				vim.notify(
					("LSP[%s] client has shut down after sending a workspace/configuration request"):format(client_id),
					vim.log.levels.ERROR
				)
				return
			end

			local response = {}
			for _, item in ipairs(params.items) do
				if item.section then
					local value = lookup_section(client.settings, item.section)
					if value == nil and item.section == "" then
						value = client.settings
					end
					if value == nil then
						value = vim.NIL
					end
					table.insert(response, value)
				end
			end
			return response
		end,
	},
	on_init = function(config)
		local root_dir = vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
		config.settings.workspaceFolder = {
			uri = root_dir,
			name = vim.fn.fnamemodify(root_dir, ":t"),
		}

		if
			vim.fn.filereadable(root_dir .. "/eslint.config.cjs") == 1
			or vim.fn.filereadable(root_dir .. "/eslint.config.cts") == 1
			or vim.fn.filereadable(root_dir .. "/eslint.config.js") == 1
			or vim.fn.filereadable(root_dir .. "/eslint.config.mjs") == 1
			or vim.fn.filereadable(root_dir .. "/eslint.config.mts") == 1
			or vim.fn.filereadable(root_dir .. "/eslint.config.ts") == 1
		then
			config.settings.experimental.useFlatConfig = true
		end

		local pnp_cjs = root_dir .. "/.pnp.cjs"
		local pnp_js = root_dir .. "/.pnp.js"
		if vim.uv.fs_stat(pnp_cjs) or vim.uv.fs_stat(pnp_js) then
			config.cmd = vim.list_extend({ "yarn", "exec" }, config.cmd)
		end
	end,
	root_markers = {
		".eslintrc",
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.yaml",
		".eslintrc.yml",
		".eslintrc.json",
		"eslint.config.js",
		"eslint.config.mjs",
		"eslint.config.cjs",
		"eslint.config.ts",
		"eslint.config.mts",
		"eslint.config.cts",
	},
	settings = {
		codeAction = {
			disableRuleComment = { enable = true, location = "separateLine" },
			showDocumentation = { enable = true },
		},
		codeActionOnSave = { mode = "all" },
		experimental = { useFlatConfig = false },
		format = false,
		nodePath = get_node_path(),
		onIgnoredFiles = "off",
		packageManager = nil,
		problems = { shortenToSingleLine = false },
		quiet = false,
		rulesCustomizations = {},
		run = "onType",
		useESLintClass = true,
		validate = "on",
		workingDirectory = { mode = "location" },
		---@diagnostic disable-next-line: assign-type-mismatch
		workspaceFolder = get_workspace_folder(0),
	},
}
