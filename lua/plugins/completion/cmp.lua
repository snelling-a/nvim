---@type LazySpec
local M = { "hrsh7th/nvim-cmp" }

M.dependencies = {
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-path",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	{
		"hrsh7th/cmp-cmdline",
		event = { "CmdlineEnter" },
	},
}

M.event = { "InsertEnter" }

---@diagnostic disable-next-line: assign-type-mismatch
M.version = false

---@param opts cmp.ConfigSchema
function M.config(_, opts)
	for _, source in ipairs(opts.sources) do
		source.group_index = source.group_index or 1
	end

	vim.opt.completeopt = { "menu", "menuone", "noselect" }
	local cmp = require("cmp")

	cmp.setup(opts)

	---@diagnostic disable-next-line: missing-fields
	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	---@diagnostic disable-next-line: missing-fields
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline({
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<CR>"] = function(fallback)
				if cmp.visible() and cmp.get_selected_entry() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
					cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
				else
					fallback()
				end
			end,
		}),
		sources = cmp.config.sources({
			{ name = "path" },
			{ name = "cmdline" },
		}),
	})
end

---@return cmp.Config
function M.opts()
	vim.api.nvim_set_hl(0, "CmpGhostText", { link = "TSComment", default = true })
	local cmp = require("cmp")
	local defaults = require("cmp.config.default")()
	local luasnip = require("luasnip")

	---@type cmp.ConfigSchema
	---@diagnostic disable-next-line: missing-fields
	return {
		---@diagnostic disable-next-line: missing-fields
		snippet = {
			expand = function(args)
				vim.snippet.expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-CR>"] = function(fallback)
				cmp.abort()
				fallback()
			end,
			["<C-e>"] = cmp.mapping.abort(),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-Space>"] = cmp.mapping.complete(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
			["<Tab>"] = cmp.mapping(function(fallback)
				if luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp", group_index = 1 },
			{ name = "luasnip" },
			{ name = "path", group_index = 1 },
			{ name = "buffer", group_index = 2 },
		}),
		---@diagnostic disable-next-line: missing-fields
		formatting = {
			format = function(_, item)
				local icons = require("ui.icons").cmp

				if icons[item.kind] then
					item.kind = ("%s%s"):format(icons[item.kind], item.kind)
				end

				return item
			end,
		},
		window = {
			---@diagnostic disable-next-line: missing-fields
			completion = { border = "rounded" },
			---@diagnostic disable-next-line: missing-fields
			documentation = { border = "rounded" },
		},
		experimental = {
			ghost_text = false,
		},
		sorting = defaults.sorting,
	}
end

return M
