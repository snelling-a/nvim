local Logger = require("util.logger"):new("Mason")

local is_mlspc_ok, mlspc = pcall(require, "mason-lspconfig")
local is_registry_ok, registry = pcall(require, "mason-registry")

local all_servers = is_mlspc_ok and vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package) or {}

local ensure_installed = {} ---@type string[]

---@class Mason
local M = {}

--- Install any servers/linters/formatters that aren't already installed
--- or update if there is an update available
---@param packages string[] list of Mason packages
function M.ensure_installed(packages)
	if not is_registry_ok then
		Logger:warn("Unable to access mason registry")
		return
	end

	registry.refresh(function()
		for _, package_name in pairs(packages or {}) do
			local package = registry.get_package(package_name)
			local name = package.name
			if not package:is_installed() then
				Logger:info(("Installing `%s`"):format(name))

				package:install()
			else
				package:check_new_version(function(success, result_or_err)
					if success then
						Logger:info(("Updating `%s` to %s"):format(name, result_or_err.latest_version))

						package:install():on("closed", function()
							Logger:info(("`%s` updated"):format(name))
						end)
					end
				end)
			end
		end
	end)
end

---@param lsp LSP
---@return string[] packages Mason packages
function M.get_ensure_installed(lsp)
	if not is_mlspc_ok then
		return {}
	end

	for server, server_opts in pairs(lsp:get_servers()) do
		if server_opts then
			server_opts = server_opts == true and {} or server_opts
			if server_opts.mason == false or not vim.tbl_contains(all_servers, server) then
				lsp:setup(server)
			else
				table.insert(ensure_installed, server)
			end
		end
	end

	return ensure_installed
end

---@param lsp LSP
function M.install_ensured(lsp)
	if is_mlspc_ok then
		mlspc.setup({
			ensure_installed = ensure_installed,
			handlers = {
				function(server_name)
					lsp:setup(server_name)
				end,
			},
		})
	end
end

return M
