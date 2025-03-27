---@type LazySpec
return {
	"saghen/blink.cmp",
	dependencies = { "echasnovski/mini.icons", "giuxtaposition/blink-cmp-copilot", "rafamadriz/friendly-snippets" },
	event = { "CmdlineEnter", "InsertEnter" },
	build = "cargo build --release",
	version = "1.*",
	---@type blink.cmp.Config
	opts = {
		completion = {
			documentation = {
				window = { border = "rounded" },
			},
			menu = {
				border = "rounded",
				draw = {
					components = {
						kind_icon = {
							text = function(ctx)
								if ctx.kind == "Copilot" then
									return require("icons").servers.copilot
								end
								---@type string, string, boolean
								local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
								return kind_icon
							end,
							highlight = function(ctx)
								---@type string, string, boolean
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
						kind = {
							highlight = function(ctx)
								---@type string, string, boolean
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
					},
				},
			},
		},
		keymap = { preset = "enter" },
		sources = {
			default = { "lsp", "snippets", "copilot", "path", "buffer" },
			providers = {
				copilot = { async = true, module = "blink-cmp-copilot", name = "copilot" },
			},
		},
	},
}
