local status_ok, noice = pcall(require, "noice")
if not status_ok or vim.g.started_by_firenvim then
	return
end

noice.setup({
	cmdline = {
		view = "cmdline",
	},
	commands = {
		history = {
			view = "split",
		},
	},
	lsp = {
		progress = {
			enabled = false,
		},
		hover = {
			enabled = false,
		},
		signature = {
			enabled = false,
		},
	},
	routes = {
		{
			filter = {
				any = {
					{ event = "msg_show", find = "%d+ change" },
					{ event = "msg_show", find = "%d+ line .*" },
					{ event = "msg_show", find = "%d+ .* line" },
					{ event = "msg_show", find = "search hit .*, continuing at .*" },
					{ event = "msg_show", find = "written" },
					{ event = "msg_show", kind = "emsg", find = "Cannot write" },
					{ event = "msg_show", kind = "emsg", find = "Pattern not found" },
					{ event = "msg_show", kind = "wmsg", find = "telescope" },
					{ event = "notify", kind = "warn", find = "[telescope.actions.set.edit]" },
				},
			},
			opts = { skip = true },
		},
	},
})
