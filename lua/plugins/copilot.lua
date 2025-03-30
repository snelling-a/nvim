---@type LazySpec
return {
	"zbirenbaum/copilot.lua",
	cmd = { "Copilot" },
	build = ":Copilot auth",
	event = { "InsertEnter" },
	opts = {
		filetypes = { markdown = true },
		panel = { enabled = false },
		suggestion = {
			auto_trigger = true,
			keymap = {
				accept = "<tab>",
			},
		},
	},
}
