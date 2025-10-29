local Icons = require("icons")

---@type LazySpec
return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewFileHistory", "DiffviewOpen" },
	---@type DiffviewConfig
	opts = {
		show_help_hints = false, -- Show hints for how to open the help panel
		watch_index = true, -- Update views and index buffers when the git index changes.
		icons = { -- Only applies when use_icons is true.
			folder_closed = Icons.misc.folder_closed,
			folder_open = Icons.misc.folder_open,
		},
		signs = {
			fold_closed = Icons.fillchars.foldclose,
			fold_open = Icons.fillchars.foldopen,
			done = Icons.misc.done,
		},
		hooks = {
			diff_buf_read = function(_bufnr)
				vim.opt_local.wrap = false
				vim.opt_local.list = false
			end,
		},
	},
}
