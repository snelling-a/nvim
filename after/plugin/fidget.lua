local icons = require("utils.icons").progress

require("fidget").setup({
	text = { spinner = "dots", done = "", commenced = icons.pending, completed = icons.done },
	timer = { fidget_decay = 1500 },
	fmt = {
		stack_upwards = false,
		fidget = function(fidget_name, spinner) return string.format("%s %s ", fidget_name, spinner) end,
	},
})
