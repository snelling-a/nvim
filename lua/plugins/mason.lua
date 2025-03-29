---@type LazySpec
return {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	dependencies = {
		"mfussenegger/nvim-lint",
		"stevearc/conform.nvim",
		{ "b0o/SchemaStore.nvim", lazy = true },
	},
	config = function()
		require("mason").setup({
			-- ui = { border = "rounded" },
		})

		local mason_registry = require("mason-registry")

		local installed = false

		local ENSURE_INSTALLED = require("user.lsp.util").get_ensure_intalled()

		---@param package Package
		local function do_install(package)
			package:once("install:success", function()
				vim.schedule(function()
					vim.notify(string.format("[ %s ] successfully installed", package.name))
				end)
			end)
			package:once("install:failed", function()
				vim.schedule(function()
					vim.notify(string.format("[ %s ] failed to install", package.name), vim.log.levels.ERROR)
				end)
			end)
			if not installed then
				installed = true
			end
			package:install()
		end

		local function ensure_installed()
			for _, name in ipairs(ENSURE_INSTALLED or {}) do
				local is_server, package = pcall(mason_registry.get_package, name)
				if is_server then
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
		end

		if mason_registry.refresh then
			mason_registry.refresh(ensure_installed)
		else
			ensure_installed()
		end
	end,
}
