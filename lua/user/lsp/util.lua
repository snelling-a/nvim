local ensure_installed = { "js-debug-adapter" }

local function get_formatters()
	local all_formatters = require("conform").list_all_formatters() or {}
	local formatters = {}

	for _, formatter in ipairs(all_formatters) do
		vim.list_extend(formatters, { formatter.name })
	end

	return formatters
end

local function get_linters()
	local linters_by_ft = require("lint").linters_by_ft or {}
	local linters = {}

	for _, linter in pairs(linters_by_ft) do
		vim.list_extend(linters, linter)
	end

	return linters
end

local M = {}

function M.get_ensure_intalled()
	local servers = M.get_all_client_names()
	local formatters = get_formatters()
	local linters = get_linters()

	vim.list_extend(ensure_installed, servers)
	vim.list_extend(ensure_installed, formatters)
	vim.list_extend(ensure_installed, linters)

	return ensure_installed
end

---@return string[] Names list of all active clients
function M.get_client_names()
	---@type string[]
	local names = {}

	for _, client in pairs(vim.lsp.get_clients()) do
		vim.list_extend(names, { client.name })
	end

	return names
end

---@return string[] Names list of all configured clients
function M.get_all_client_names()
	---@type string[]
	local servers = {}

	vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
		:map(function(server_config_path)
			return vim.fs.basename(server_config_path):match("^(.*)%.lua$")
		end)
		:each(function(server_name)
			vim.list_extend(servers, { server_name })
		end)

	return servers
end

return M
