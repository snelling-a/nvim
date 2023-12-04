local Util = require("util")

---@class lsp.util
local M = {}

---@param server string
---@param cond fun(root_dir, config): boolean
function M.disable(server, cond)
	local util = require("lspconfig.util")
	local def = M.get_config(server)
	---@diagnostic disable-next-line: undefined-field
	def.document_config.on_new_config = util.add_hook_before(
		def.document_args.masonig.on_new_config,
		function(config, root_dir)
			if cond(root_dir, config) then
				config.enabled = false
			end
		end
	)
end

---@param opts? lsp.Client.filter
function M.get_clients(opts)
	local ret ---@type lsp.Client[]
	if vim.lsp.get_clients then
		ret = vim.lsp.get_clients(opts)
	else
		---@diagnostic disable-next-line: deprecated
		ret = vim.lsp.get_active_clients(opts)
		if opts and opts.method then
			---@param client lsp.Client
			ret = vim.tbl_filter(function(client)
				return client.supports_method(opts.method, { bufnr = opts.bufnr })
			end, ret)
		end
	end
	return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@return lspconfig.Config|{document_args:table}
function M.get_config(server)
	local configs = require("lspconfig.configs")
	return rawget(configs, server)
end

---@param args SetupLanguageArgs
function M.setup_language(args)
	local table_or_string = Util.table_or_string
	local function list_extend(opts, list_args)
		vim.list_extend(opts, table_or_string(list_args))
	end
	local langs = table_or_string(args.langs)

	return {
		{
			"nvim-treesitter/nvim-treesitter",
			opts = function(_, opts)
				if type(opts.ensure_installed) == "table" then
					list_extend(opts.ensure_installed, (args.ts or langs))
				end
			end,
		},
		{
			"williamboman/mason.nvim",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				list_extend(opts.ensure_installed, args.formatters)
				list_extend(opts.ensure_installed, args.linters)
			end,
		},
		args.linters and {
			"mfussenegger/nvim-lint",
			opts = function(_, opts)
				if not opts.linters_by_ft then
					opts.linters_by_ft = {}
				end

				for _, v in pairs(langs) do
					if not opts.linters_by_ft[v] then
						opts.linters_by_ft[v] = table_or_string(args.linters)
					else
						opts.linters_by_ft[v] = list_extend(opts.linters_by_ft[v], args.linters)
					end
				end
			end,
		},
		args.formatters and {
			"stevearc/conform.nvim",
			opts = function(_, opts)
				if not opts.formatters_by_ft then
					opts.formatters_by_ft = {}
				end

				for _, v in pairs(langs) do
					opts.formatters_by_ft[v] =
						vim.list_extend(opts.formatters_by_ft[v] or {}, table_or_string(args.formatters))
				end
			end,
		},
	}
end

return M
