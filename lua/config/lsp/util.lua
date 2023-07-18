local util = require("config.util")

local LspUtil = {}

---wrapper for vim.api.nvim_buf_set_keymap
---@param bufnr integer 'buffer number'
---@param lhs string 'keymap'
---@param rhs string|function 'keymap functionality'
---@param desc string description
function LspUtil.bind(bufnr, lhs, rhs, desc)
	local opts = { buffer = bufnr, desc = desc }

	return util.nmap(lhs, rhs, opts)
end
---wrapper for lspconfig.util.root_pattern
---@param config_files string[]
---@return function (startpath: any) -> string|unknown|nil
function LspUtil.get_root_pattern(config_files) return require("lspconfig").util.root_pattern(unpack(config_files)) end

---wrapper for lspconfig.util.root_pattern for graphql language servers
---@return function (startpath: any) -> string|unknown|nil
function LspUtil.get_graphql_root_pattern()
	return LspUtil.get_root_pattern({
		".graphqlrc*",
		".graphql.config.*",
		"graphql.config.*",
		"relay.config.*",
	})
end

local server_path = "$XDG_CONFIG_HOME/nvim/lua/config/lsp/server"

function LspUtil.setup_lsp_servers(opts)
	local registry = require("mason-registry")

	registry.refresh(function()
		for index, value in vim.fs.dir(server_path) do
			if value ~= "file" then
				return
			end

			local server_name = index:gsub(".lua", "")
			local require_path = "config.lsp.server." .. server_name

			local server_config = require(require_path) or {}
			local pkg = server_config.mason_name or server_name

			if pkg == "relay_lsp" then
				return
			else
				local package = registry.get_package(pkg)

				if not package:is_installed() then
					package:install()
				end
			end

			require(require_path).setup(opts)
		end
	end)
end

return LspUtil
