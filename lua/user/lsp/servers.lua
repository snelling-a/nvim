---@param client_name string
---@return vim.lsp.Client|nil
local function get_client_by_name(client_name)
	local clients = vim.lsp.get_clients()
	for _, client in ipairs(clients) do
		if client.name == client_name then
			return client
		end
	end

	return nil
end

local typescript_inlay_hints = {
	enumMemberValues = { enabled = true },
	functionLikeReturnTypes = { enabled = true },
	parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
	parameterTypes = { enabled = true },
	propertyDeclarationTypes = { enabled = true },
	variableTypes = { enabled = true, suppressWhenArgumentMatchesName = true },
}

local lspconfig = require("lspconfig")
---@param snippet_support? boolean Whether the client should support snippets
---@return lsp.ClientCapabilities
local function get_capabilities(snippet_support)
	snippet_support = snippet_support ~= false

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = snippet_support

	return capabilities
end
---@class lsp.Config: lspconfig.Config
---@field cmd? string[]|fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient

---@class user.Lsp.servers: {string:lsp.Config}[]
local servers = {
	bashls = {},
	clangd = {},
	css_variables = {},
	cssls = { capabilities = get_capabilities() },
	denols = {
		settings = {
			deno = { inlayHints = typescript_inlay_hints },
		},
	},
	docker_compose_language_service = {},
	dockerls = {},
	emmet_ls = { capabilities = get_capabilities(false) },
	eslint = {
		settings = {
			useESLintClass = true,
			codeActionOnSave = { mode = "all" },
			format = false,
			nodePath = Config.util.get_node_path(),
			workingDirectory = { mode = "location" },
			---@diagnostic disable-next-line: assign-type-mismatch
			workspaceFolder = function(bufnr)
				local git_dir = vim.fs.root(bufnr, { ".git" }) or ""

				return {
					uri = vim.uri_from_fname(git_dir),
					name = vim.fn.fnamemodify(git_dir, ":t"),
				}
			end,
		},
		handlers = {
			---@param params lsp.ConfigurationParams
			---@param ctx lsp.HandlerContext
			---@return table|nil
			[vim.lsp.protocol.Methods.workspace_configuration] = function(_, params, ctx)
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
						"LSP[" .. client_id .. "] client has shut down after sending a workspace/configuration request",
						vim.log.levels.ERROR
					)
					return
				end
				if not params.items then
					return {}
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
		on_init = function()
			Config.autocmd.create_autocmd({ "BufWritePre" }, {
				group = "EslintLsp",
				command = "EslintFixAll",
				pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
			})
		end,
	},
	harper_ls = {
		filetypes = { "markdown", "text" },
		settings = {
			["harper-ls"] = {
				linters = { avoid_curses = false },
				userDictPath = spellfile,
			},
		},
	},
	html = { capabilities = get_capabilities(false) },
	jsonls = {
		capabilities = get_capabilities(),
		on_new_config = function(new_config)
			---@diagnostic disable-next-line: inject-field
			new_config.settings.json.schemas = new_config.settings.json.schemas or {}
			vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
		end,
		settings = { json = { format = { enable = false }, validate = { enable = true } } },
		commands = {
			SortJSON = {
				function()
					vim.cmd([[%!jq . --sort-keys]])
				end,
				desc = "Sort JSON keys alphabetically",
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				codeLens = { enable = true },
				completion = { callSnippet = "Replace" },
				diagnostics = {
					groupFileStatus = {
						["ambiguity"] = "Opened",
						["await"] = "Opened",
						["codestyle"] = "None",
						["duplicate"] = "Opened",
						["global"] = "Opened",
						["luadoc"] = "Opened",
						["redefined"] = "Opened",
						["strict"] = "Opened",
						["strong"] = "Opened",
						["type-check"] = "Opened",
						["unbalanced"] = "Opened",
						["unused"] = "Opened",
					},
					unusedLocalExclude = { "_*" },
				},
				doc = { privateName = { "^_" } },
				hint = {
					arrayIndex = "Disable",
					enable = true,
					paramName = "Literal",
					paramType = true,
					semicolon = "Disable",
					setType = false,
				},
			},
		},
	},
	markdown_oxide = {
		capabilities = {
			workspace = {
				didChangeWatchedFiles = {
					dynamicRegistration = true,
				},
			},
		},
		commands = {
			Today = {
				function()
					local client = get_client_by_name("markdown_oxide")
					if not client then
						return
					end

					client:exec_cmd({ title = "today", command = "jump", arguments = { "today" } })
				end,
				desc = "Open today's daily note",
			},
			Tomorrow = {
				function()
					local client = get_client_by_name("markdown_oxide")
					if not client then
						return
					end

					client:exec_cmd({ title = "tomorrow", command = "jump", arguments = { "tomorrow" } })
				end,
				desc = "Open tomorrow's daily note",
			},
			Yesterday = {
				function()
					local client = get_client_by_name("markdown_oxide")
					if not client then
						return
					end

					client:exec_cmd({ title = "yesterday", command = "jump", arguments = { "yesterday" } })
				end,
				desc = "Open yesterday's daily note",
			},
		},
		enabled = vim.fn.getcwd() == os.getenv("HOME") .. "/notes",
	},
	marksman = {},
	prismals = {},
	sqlls = {},
	taplo = {
		settings = {
			evenBetterToml = {
				schema = { enabled = true, repositoryEnabled = true },
			},
		},
	},
	vimls = {},
	vtsls = {
		name = "ts_ls",
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		handlers = {
			---@param err lsp.ResponseError
			---@param result any
			---@param ctx lsp.HandlerContext
			[vim.lsp.protocol.Methods.textDocument_publishDiagnostics] = function(err, result, ctx)
				local okay, error_translator = pcall(require, "ts-error-translator")
				if not okay then
					vim.notify("ts-error-translator is not installed", vim.log.levels.ERROR, { once = true })
					vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
					return
				end
				error_translator.translate_diagnostics(err, result, ctx)
				vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
			end,
		},
		root_dir = lspconfig.util.root_pattern("package.json"),
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
			typescript = {
				updateImportsOnFileMove = { enabled = "always" },
				suggest = { completeFunctionCalls = true },
				inlayHints = typescript_inlay_hints,
			},
			javascript = {
				updateImportsOnFileMove = { enabled = "always" },
				suggest = { completeFunctionCalls = true },
				inlayHints = typescript_inlay_hints,
			},
		},
	},
	yamlls = {
		capabilities = {
			textDocument = {
				foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
			},
		},
		commands = {
			SortYAML = {
				function()
					vim.cmd([[%!yq 'sort_keys(..)' %]])
				end,
				desc = "Sort yaml keys alphabetically",
			},
		},
		on_new_config = function(new_config)
			---@type table
			---@diagnostic disable-next-line: inject-field
			new_config.settings.yaml.schemas = vim.tbl_deep_extend(
				"force",
				new_config.settings.yaml.schemas or {},
				require("schemastore").yaml.schemas()
			)
		end,
		settings = {
			redhat = {
				telemetry = { enabled = false },
			},
			yaml = {
				keyOrdering = false,
				format = {
					enable = true,
				},
				validate = true,
				schemaStore = { enable = false, url = "" },
			},
		},
	},
}

return servers
