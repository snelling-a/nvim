---@type LazySpec
return {
	"saghen/blink.cmp",
	dependencies = { "echasnovski/mini.icons", "rafamadriz/friendly-snippets" },
	event = { "CmdlineEnter", "InsertEnter" },
	build = "cargo build --release",
	---@type blink.cmp.Config
	opts = {
		completion = {
			menu = {
				draw = {
					components = {
						kind_icon = {
							text = function(ctx)
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
			default = { "lsp", "snippets", "path", "buffer" },
		},
	},
}
