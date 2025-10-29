---@type LazySpec
return {
	"saghen/blink.cmp",
	dependencies = { "nvim-mini/mini.icons", "rafamadriz/friendly-snippets" },
	event = { "CmdlineEnter", "InsertEnter" },
	version = "1.*",
	---@type blink.cmp.Config
	opts = {
		completion = {
			accept = {
				auto_brackets = { enabled = false },
			},
			list = { max_items = 50 },
			documentation = { auto_show = true },
			menu = {
				draw = {
					components = {
						kind_icon = {
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
			default = function()
				local sources = { "lsp", "buffer" }
				local ok, node = pcall(vim.treesitter.get_node)

				if ok and node then
					if not vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
						table.insert(sources, "path")
					end
					if node:type() ~= "string" then
						table.insert(sources, "snippets")
					end
				end

				return sources
			end,
		},
	},
}
