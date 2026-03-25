vim.pack.add({ { src = "https://github.com/brianhuster/live-preview.nvim" } }, { load = false })

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown", "html" },
	once = true,
	callback = function()
		vim.cmd.packadd("live-preview.nvim")
	end,
})
