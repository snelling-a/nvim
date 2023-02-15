local utils = require("utils")
local actions = require("diffview.actions")

local win_config = { position = "left", width = 35, win_opts = {} }

local function toggle_help(diffview)
	return { "n", "?", actions.help({ "view", diffview }), { desc = "Open the help panel" } }
end

utils.nmap("<leader>gs", vim.cmd.DiffviewOpen)

require("diffview").setup({
	enhanced_diff_hl = true,
	view = {
		default = { layout = "diff2_horizontal", winbar_info = true },
		merge_tool = { layout = "diff3_horizontal", disable_diagnostics = true, winbar_info = true },
		file_history = { layout = "diff2_horizontal", winbar_info = true },
	},
	file_history_panel = { win_config = win_config },
	commit_log_panel = { win_config = win_config },
	keymaps = {
		disable_defaults = false,
		diff1 = { toggle_help("diff1") },
		diff2 = { toggle_help("diff2") },
		diff3 = { toggle_help("diff3") },
		diff4 = { toggle_help("diff4") },
		file_panel = { toggle_help("file_panel") },
		file_history_panel = { toggle_help("file_history_panel") },
		option_panel = { toggle_help("option_panel") },
	},
})
