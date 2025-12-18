vim.pack.add({
	{ src = "https://github.com/esmuellert/vscode-diff.nvim", version = "next" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
}, {
	load = function()
		vim.api.nvim_create_user_command("CodeDiff", function()
			vim.api.nvim_del_user_command("CodeDiff")
			vim.cmd.packadd("vscode-diff.nvim")
			vim.cmd.packadd("nui.nvim")
			vim.cmd.CodeDiff()
		end, {})
	end,
})
