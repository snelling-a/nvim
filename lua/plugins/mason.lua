local Icons = require("config.ui.icons").progress
local Logger = require("config.util.logger"):new("Mason")

--- @type LazySpec
local M = {
	"williamboman/mason.nvim",
}

M.build = ":MasonUpdate"

M.cmd = {
	"Mason",
	"MasonInstall",
	"MasonUpdate",
	"MasonUpdateAll",
}

M.opts = {
	ui = {
		border = "rounded",
		icons = {
			package_installed = Icons.done,
			package_pending = Icons.pending,
			package_uninstalled = Icons.trash,
		},
	},
}

function M.config(_, opts)
	require("mason").setup(opts)

	vim.api.nvim_create_user_command("MasonUpdateAll", function()
		local ok, registry = pcall(require, "mason-registry")
		if not ok then
			Logger:warn("Unable to access mason registry")

			return
		end
		Logger:info("Checking for package updates...")

		registry.update(vim.schedule_wrap(function(success, updated_registries)
			if success then
				local installed_pkgs = registry.get_installed_packages()
				local running = #installed_pkgs
				local no_pkgs = running == 0

				if no_pkgs then
					Logger:info("No updates available")
				else
					local updated = false

					for _, pkg in ipairs(installed_pkgs) do
						pkg:check_new_version(function(update_available, version)
							if update_available then
								updated = true

								Logger:info(("Updating `%s` to %s"):format(pkg.name, version.latest_version))

								pkg:install():on("closed", function()
									running = running - 1
									if running == 0 then
										Logger:info("Update Complete")
									end
								end)
							else
								running = running - 1

								if running == 0 then
									if updated then
										Logger:info("Update Complete")
									else
										Logger:info("No updates available")
									end
								end
							end
						end)
					end
				end
			else
				Logger:error(("Failed to update registries: %s"):format(updated_registries))
			end
		end))
	end, {})
end

return M
