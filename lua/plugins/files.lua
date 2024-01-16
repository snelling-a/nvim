local desc = "[O]pen mini.files"

---@type LazySpec
local M = { "echasnovski/mini.files" }

M.keys = {
	{ "<M-o>", desc = desc },
}

M.opts = {
	content = {
		prefix = function(fs_entry)
			if fs_entry.fs_type == "directory" then
				return require("ui").icons.file.folder_open, "MiniFilesDirectory"
			end
			return _G.MiniFiles.default_prefix(fs_entry)
		end,
	},
	mappings = { go_in_plus = "<CR>", show_help = "?" },
	windows = { preview = true, width_focus = 50, width_preview = 50 },
}

function M.config(_, opts)
	local files = require("mini.files")

	files.setup(opts)

	local Util = require("util")

	local map = require("keymap").nmap
	map("<M-o>", function()
		if not files.close() then
			local path = Util.is_file() and vim.api.nvim_buf_get_name(0) or vim.fn.getcwd()

			files.open(path)
		end
	end, { desc = desc })

	---@param bufnr integer
	---@param lhs "s"|"t"|"v"
	local function map_split(lhs, bufnr)
		local commands = {
			s = "split",
			t = "tabnew",
			v = "vsplit",
		}
		local command = commands[lhs]

		local function rhs()
			local fs_entry = files.get_fs_entry()
			local is_at_file = fs_entry ~= nil and fs_entry.fs_type == "file"

			if not is_at_file then
				return
			end

			-- Make new window and set it as target
			local new_target_window
			local current_window = files.get_target_window()

			if not current_window then
				return
			end

			vim.api.nvim_win_call(current_window, function()
				vim.cmd(command)
				new_target_window = vim.api.nvim_get_current_win()
			end)

			files.set_target_window(new_target_window)
			files.go_in({ close_on_file = true })
		end

		local map_desc = ("Open %s"):format(command)
		map(("<C-%s>"):format(lhs), rhs, { buffer = bufnr, desc = map_desc })
	end

	local Autocmd = require("autocmd")

	vim.api.nvim_create_autocmd("User", {
		callback = function(args)
			local bufnr = args.data.buf_id

			map_split("s", bufnr)
			map_split("t", bufnr)
			map_split("v", bufnr)
		end,
		group = Autocmd.augroup("MiniFilesKeymaps"),
		pattern = "MiniFilesBufferCreate",
	})

	vim.api.nvim_create_autocmd("User", {
		callback = function(ev)
			require("lsp")--[[@as LSP]]
				.rename(ev.data.from, ev.data.to)
		end,
		group = Autocmd.augroup("MiniFilesRename"),
		pattern = "MiniFilesActionRename",
	})
end

return M
