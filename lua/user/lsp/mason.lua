local mason_registry = require("mason-registry")

local ENSURE_INSTALLED = { "js-debug-adapter" }
local all_formatters = require("conform").list_all_formatters()
for _, formatter in ipairs(all_formatters) do
	vim.list_extend(ENSURE_INSTALLED, { formatter.name })
end

local linters = require("lint").linters_by_ft
for _, linter in pairs(linters) do
	vim.list_extend(ENSURE_INSTALLED, linter)
end

local installed = false
local installed_packages = {}

---@param package Package
local function do_install(package)
	package:once("install:success", function()
		vim.notify(string.format("[ %s ] successfully installed", package.name))
	end)
	package:once("install:failed", function()
		vim.notify(string.format("[ %s ] failed to install", package.name), vim.log.levels.ERROR)
	end)
	if not installed then
		installed = true
	end
	table.insert(installed_packages, package.name)
	package:install()
end

---@class user.Lsp.mason
local M = {}

function M.check_install()
	installed = false
	installed_packages = {}
	local ensure_installed = function()
		for _, name in ipairs(ENSURE_INSTALLED or {}) do
			local package = mason_registry.get_package(name)
			if package:is_installed() then
				package:check_new_version(function(okay, result_or_err)
					if not okay then
						return
					end

					package:install({ version = result_or_err.latest_version })
				end)
			else
				do_install(package)
			end
		end
	end

	if mason_registry.refresh then
		mason_registry.refresh(ensure_installed)
	else
		ensure_installed()
	end
end

return M
