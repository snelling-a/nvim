---@type LazySpec
return {
	"nvim-mini/mini.files",
	dependencies = { "nvim-mini/mini.icons" },
	keys = {
		{ "<M-o>", desc = "MiniFiles: Toggle" },
	},
	config = function()
		local files = require("mini.files")
		files.setup({
			mappings = { go_in_plus = "<CR>", show_help = "?" },
			windows = { preview = true, width_focus = 50, width_preview = 50 },
		})

		local show_dotfiles = true
		local function filter_show()
			return true
		end

		---@param fs_entry {name: string}
		---@return boolean # Whether the file is a dotfile
		local function filter_hide(fs_entry)
			return not vim.startswith(fs_entry.name, ".")
		end

		local toggle_dotfiles = function()
			show_dotfiles = not show_dotfiles
			local new_filter = show_dotfiles and filter_show or filter_hide
			files.refresh({ content = { filter = new_filter } })
		end

		local map = vim.keymap.set

		map("n", "<M-o>", function()
			if not files.close() then
				local path = vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) or vim.fn.getcwd()

				files.open(path, true)
			end
		end, { desc = "Toggle" })

		local group = require("user.autocmd").augroup("mini.files")

		vim.api.nvim_create_autocmd({ "User" }, {
			callback = function(args)
				---@type integer
				local bufnr = args.data.buf_id
				---@param lhs "s"|"t"|"v" Left-hand side |{lhs}| of the mapping
				local function map_split(lhs)
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

						local new_target_window = 0
						local current_window = files.get_explorer_state().target_window ---@type integer

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
					map("n", ("<C-%s>"):format(lhs), rhs, { buffer = bufnr, desc = map_desc })
				end

				map("n", ".", toggle_dotfiles, { buffer = bufnr, desc = "Toggle hidden files" })

				map_split("s")
				map_split("t")
				map_split("v")
			end,
			desc = "Set up MiniFiles keymaps",
			group = group,
			pattern = "MiniFilesBufferCreate",
		})

		require("plugins.files.git_integration")
		require("plugins.files.rename").setup()
	end,
}
