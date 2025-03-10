---@type LazySpec
return {
	"saghen/blink.cmp",
	dependencies = { "echasnovski/mini.icons", "giuxtaposition/blink-cmp-copilot", "rafamadriz/friendly-snippets" },
	event = { "CmdlineEnter", "InsertEnter" },
	build = "cargo build --release",
	-- version = "*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = { preset = "enter" },
		appearance = {
			nerd_font_variant = "mono",
			kind_icons = {
				Copilot = " ",
			},
		},
		cmdline = {
			enabled = false,
			-- completion = {
			-- 	menu = {
			-- 		auto_show = function(_ctx)
			-- 			return vim.fn.getcmdtype() == ":"
			-- 		end,
			-- 	},
			-- },
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "copilot" },
			providers = {
				copilot = {
					async = true,
					module = "blink-cmp-copilot",
					name = "copilot",
					score_offset = 100,
					transform_items = function(_, items)
						local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
						local kind_idx = #CompletionItemKind + 1
						CompletionItemKind[kind_idx] = "Copilot"
						for _, item in ipairs(items) do
							item.kind = kind_idx
						end
						return items
					end,
				},
			},
		},
		completion = {
			documentation = { window = { border = "rounded" } },
			menu = { border = "rounded", draw = { components = { kind_icon = { ellipsis = false } } } },
		},
	},
}
