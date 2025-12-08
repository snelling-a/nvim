vim.pack.add({ { src = "https://github.com/williamboman/mason.nvim", name = "mason" } }, {
	load = function()
		vim.cmd.packadd("mason")
		require("mason").setup()
	end,
})
