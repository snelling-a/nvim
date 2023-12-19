---@type LazySpec
local M = { "hrsh7th/nvim-cmp" }

M.dependencies = {
	"FelipeLema/cmp-async-path",
	"L3MON4D3/LuaSnip",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-nvim-lsp",
	"saadparwaiz1/cmp_luasnip",
}

M.event = { "InsertEnter" }

---@diagnostic disable-next-line: assign-type-mismatch
M.version = false

---@param opts cmp.ConfigSchema
function M.config(_, opts)
	for _, source in ipairs(opts.sources) do
		source.group_index = source.group_index or 1
	end

	require("cmp").setup(opts)

	if opts.experimental.ghost_text then
		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "TSComment", default = true })
	end
end

---@return cmp.Config
function M.opts()
	local cmp = require("cmp")

	---@type cmp.ConfigSchema
	return {
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
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
			["<Tab>"] = cmp.mapping(function(fallback)
				local luasnip = require("luasnip")

				if luasnip.expand_or_jump() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp", group_index = 1 },
			{ name = "luasnip", group_index = 1 },
			{ name = "async_path", group_index = 1 },
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
			completion = { border = "rounded" },
			documentation = { border = "rounded" },
		},
		experimental = { ghost_text = false },
		sorting = require("cmp.config.default")().sorting,
	}
end

return M
