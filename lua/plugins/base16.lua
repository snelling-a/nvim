---@type LazySpec
return {
	"snelling-a/base16.nvim",
	priority = 1000,
	dev = true,
	lazy = false,
	config = function()
		vim.cmd.colorscheme("base16-default-" .. vim.o.background)

		Config.autocmd.create_autocmd({ "OptionSet" }, {
			callback = function()
				vim.cmd.colorscheme("base16-default-" .. vim.o.background)
			end,
			group = "DetectDarkMode",
			pattern = { "background" },
		})
	end,
}
