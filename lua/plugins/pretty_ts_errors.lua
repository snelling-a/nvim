vim.pack.add({ "https://github.com/enochchau/nvim-pretty-ts-errors" }, { load = false })

local function ensure_npm_neovim()
	vim.system({ "npm", "list", "-g", "neovim" }, {}, function(result)
		if result.code ~= 0 then
			vim.schedule(function()
				vim.notify("Installing npm neovim package...")
			end)
			vim.system({ "npm", "install", "-g", "neovim" }, {}, function(install_result)
				vim.schedule(function()
					if install_result.code == 0 then
						vim.notify("npm neovim package installed.")
					else
						vim.notify(
							"Failed to install npm neovim package: " .. (install_result.stderr or ""),
							vim.log.levels.ERROR
						)
					end
				end)
			end)
		end
	end)
end

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	once = true,
	callback = function()
		ensure_npm_neovim()
		vim.cmd.packadd("nvim-pretty-ts-errors")

		vim.keymap.set({ "n" }, "<leader>d", require("nvim-pretty-ts-errors").show_line_diagnostics)
	end,
})

vim.api.nvim_create_autocmd({ "PackChanged" }, {
	callback = function(args)
		if
			args.data
			and args.data.spec.name == "nvim-pretty-ts-errors"
			and (args.data.kind == "install" or args.data.kind == "update")
		then
			vim.cmd.UpdateRemotePlugins()
			vim.notify("You may need to restart Neovim for nvim-pretty-ts-errors to work properly.")
		end
	end,
})
