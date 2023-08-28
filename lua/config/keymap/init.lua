vim.g.mapleader = ","

require("config.keymap.center_actions")
require("config.keymap.escape")
require("config.keymap.leader")
require("config.keymap.normal")
require("config.keymap.unimpaired")
require("config.keymap.visual")

local map = vim.keymap.set

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/I<Left><Left>]], {
	desc = "[S]earch and replace word under the cursor",
})

map(
	{
		"n",
		"v",
	},
	";",
	":",
	{
		desc = "Enter command mode with `;`",
	}
)
map(
	{
		"n",
		"v",
	},
	":",
	";",
	{
		desc = "Command is remapped to `;`",
	}
)
