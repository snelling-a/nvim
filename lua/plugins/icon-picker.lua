local IconPicker = {
	"ziontee113/icon-picker.nvim",
}

IconPicker.keys = {
	{
		"<Leader><Leader>i",
		vim.cmd.IconPickerNormal,
		desc = "[I]con picker",
	},
	{
		"<C-i>",
		vim.cmd.IconPickerInsert,
		desc = "[I]con picker",
		mode = "i",
	},
}

IconPicker.opts = {
	disable_legacy_commands = true,
}

return IconPicker