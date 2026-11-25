vim.pack.add({
	{ src = "https://github.com/esmuellert/codediff.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
}, {
	load = function()
		vim.api.nvim_create_user_command("CodeDiff", function(opts)
			vim.api.nvim_del_user_command("CodeDiff")
			vim.cmd.packadd("codediff.nvim")
			vim.cmd.packadd("nui.nvim")
			require("codediff").setup({
				diff = { compact = true, ignore_trim_whitespace = true },
			})
			vim.cmd.CodeDiff(opts.fargs)
		end, { nargs = "*" })
	end,
})
