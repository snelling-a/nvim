vim.pack.add({ { src = "https://github.com/danymat/neogen" } }, {
	load = function()
		vim.api.nvim_create_user_command("Neogen", function()
			vim.api.nvim_del_user_command("Neogen")
			vim.cmd.packadd("neogen")
			require("neogen").setup({})

			vim.cmd.Neogen()
		end, {})
	end,
})
