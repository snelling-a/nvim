if not require("utils").is_vim then
	return
end

local mini_notifications = {
	filter = {
		any = {
			{ event = "msg_show", find = "filetype=" },
			{ event = "msg_show", find = "/Users/" },
			{ event = "msg_show", find = "Hunk %d of %d" },
			{ event = "msg_show", find = "null-ls.*timeout" },
			{ event = "msg_show", find = "nvim-treesitter" },
			{ event = "msg_show", kind = "emsg", find = "Not an editor command" },
			{ event = "msg_show", kind = "lua_error", find = "key must be a positive Integer" },
			{ event = "msg_show", kind = "lua_error", find = "vim.lsp.buf.hover" },
			{ event = "notify", kind = "info", find = "Highlighting cleared" },
			{ event = "notify", kind = "info", find = "nvim-treesitter" },
			{ event = "notify", kind = "info", find = "LSP" },
			{ event = "notify", kind = "info", find = "No information available" },
			{ event = "notify", kind = "info", find = "was automatically installed" },
			{ event = "notify", kind = "warn", find = "NO! USE .!" },
			{ kind = "info", find = "was properly" },
			{ event = "msg_show", find = "No signature help available" },
		},
	},
	view = "mini",
}

local split_notifications = {
	filter = {
		any = {
			{ event = "msg_show", min_height = 10 },
			{ event = "msg_show", kind = "lua_error", find = "Error executing vim.schedule" },
		},
	},
	view = "split",
}

local hidden_notifications = {
	filter = {
		any = {
			{ event = "msg_show", find = "%d+.* line.*" },
			{ event = "msg_show", find = "%d+ change" },
			{ event = "msg_show", find = "search hit .*, continuing at .*" },
			{ event = "msg_show", find = "written" },
			{ event = "msg_show", kind = "emsg", find = "Cannot write" },
			{ event = "msg_show", kind = "emsg", find = "Pattern not found" },
			{ event = "msg_show", kind = "emsg", find = "Spell checking is not possible" },
			{ event = "msg_show", kind = "wmsg", find = "telescope" },
			{ event = "notify", kind = "warn", find = "telescope.actions.set.edit" },
			{ event = "NvimTree", kind = "message" },
		},
	},
	opts = { skip = true },
}

require("noice").setup({
	lsp = {
		progress = {
			format = {
				{ "[{data.progress.percentage}%] ", hl_group = "NoiceLspProgressTitle" },
				{ "{spinner} ", hl_group = "NoiceLspProgressSpinner" },
				{ "[{data.progress.title}] ", hl_group = "NoiceLspProgressTitle" },
			},
		},
		hover = { enabled = false },
		signature = { enabled = false },
		-- message = { enabled = false },
		documentation = { enabled = false },
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = false,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	format = { spinner = { name = "bouncingBar" } },
	-- popupmenu = { backend = "cmp" },
	presets = { bottom_search = true, long_message_to_split = true, lsp_doc_border = true },
	cmdline = { view = "cmdline" },
	routes = { hidden_notifications, mini_notifications, split_notifications },
	messages = { view_search = false },
})
