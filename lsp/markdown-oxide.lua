---@type vim.lsp.Config
return {
	workspace = {
		didChangeWatchedFiles = {
			dynamicRegistration = true,
		},
	},
	root_markers = { ".moxide.toml" },
	filetypes = { "markdown" },
	cmd = { "markdown-oxide" },
	on_attach = function(client)
		vim.api.nvim_buf_create_user_command(0, "LspToday", function()
			client:exec_cmd({ title = "Today", command = "jump", arguments = { "today" } })
		end, {
			desc = "Open today's daily note",
		})
		vim.api.nvim_buf_create_user_command(0, "LspTomorrow", function()
			client:exec_cmd({ title = "Tomorrow", command = "jump", arguments = { "tomorrow" } })
		end, {
			desc = "Open tomorrow's daily note",
		})
		vim.api.nvim_buf_create_user_command(0, "LspYesterday", function()
			client:exec_cmd({ title = "Yesterday", command = "jump", arguments = { "yesterday" } })
		end, {
			desc = "Open yesterday's daily note",
		})
	end,
	single_file_support = true,
}
