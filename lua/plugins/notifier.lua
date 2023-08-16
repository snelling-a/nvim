local Notifier = { "vigoux/notifier.nvim" }

Notifier.opts = {
	ignore_messages = {},
	components = {
		"nvim",
		"lsp",
	},
	notify = {
		clear_time = 3000,
		min_level = vim.log.levels.INFO,
	},
	component_name_recall = true,
	zindex = 50,
}

return Notifier
