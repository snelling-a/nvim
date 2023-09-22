--- @type LazySpec
local M = {
	"ziontee113/icon-picker.nvim",
}

M.keys = {
	---@diagnostic disable-next-line: missing-fields
	{
		"<Leader><Leader>i",
		vim.cmd.IconPickerNormal,
		desc = "[I]con picker",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<C-i>",
		vim.cmd.IconPickerInsert,
		desc = "[I]con picker",
		mode = "i",
	},
}

M.opts = {
	disable_legacy_commands = true,
}

return M
