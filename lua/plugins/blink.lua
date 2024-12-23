---@type LazySpec
return {
	"saghen/blink.cmp",
	build = "cargo build --release",
	dependencies = { "giuxtaposition/blink-cmp-copilot", "rafamadriz/friendly-snippets" },
	event = { "InsertEnter" },
	config = function()
		local blink = require("blink.cmp")

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		local opts = {
			appearance = { kind_icons = Config.icons.kind_icons, nerd_font_variant = "mono" },
			completion = {
				accept = {
					auto_brackets = { enabled = true },
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = { border = "rounded" },
				},
				menu = {
					auto_show = false,
					border = "rounded",
					draw = {
						treesitter = { "lsp" },
					},
					winblend = vim.o.pumblend,
				},
			},
			keymap = {
				preset = "enter",
				["<Tab>"] = {
					Config.keymap.maps.complete({ "snippet_forward", "copilot_accept" }),
					"fallback",
				},
			},
			sources = {
				default = { "copilot", "lsp", "path", "snippets", "buffer" },
				cmdline = {},
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
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},
		}

		blink.setup(opts)
	end,
}
