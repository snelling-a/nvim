vim.pack.add({
	{ src = "https://github.com/esmuellert/codediff.nvim", version = "next" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
}, {
	load = function()
		vim.api.nvim_create_user_command("CodeDiff", function()
			vim.api.nvim_del_user_command("CodeDiff")
			vim.cmd.packadd("codediff.nvim")
			vim.cmd.packadd("nui.nvim")
			vim.cmd.CodeDiff()
		end, { nargs = "*" })
	end,
})
