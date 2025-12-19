vim.pack.add({ "https://github.com/mistweaverco/kulala.nvim" }, { load = false })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "http",
	once = true,
	callback = function()
		vim.cmd.packadd("kulala.nvim")
		require("kulala").setup({
			global_keymaps = true,
			global_keymaps_prefix = "<leader>r",
			split_direction = "vertical",
			default_env = "dev",
			generate_bug_report = false,
		})

		-- Install kulala_http parser if not present
		local ok, parsers = pcall(require, "nvim-treesitter.parsers")
		if ok and parsers.kulala_http and not parsers.kulala_http.installed then
			vim.cmd("TSInstall kulala_http")
		end
	end,
})
