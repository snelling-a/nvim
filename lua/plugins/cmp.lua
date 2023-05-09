local icons = require("config.ui.icons")

local formatting = {
	fields = { "kind", "abbr", "menu" },
	format = function(entry, vim_item)
		vim_item.kind = icons.kind_icons[vim_item.kind]
		vim_item.menu = icons.cmp[entry.source.name]
		return vim_item
	end,
}

local function luasnip_extend()
	local luasnip = require("luasnip")

	luasnip.filetype_extend("javascript", { "html" })
	luasnip.filetype_extend("javascriptreact", { "html", "javascript" })
	luasnip.filetype_extend("typescript", { "html", "javascript" })
	luasnip.filetype_extend("typescriptreact", { "html", "javascript" })
end

local M = { "hrsh7th/nvim-cmp" }

M.cond = not vim.g.vscode

M.dependencies = {
	"davidsierradz/cmp-conventionalcommits",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lsp-document-symbol",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-path",
	"L3MON4D3/LuaSnip",
	"neovim/nvim-lspconfig",
	"petertriho/cmp-git",
	"ray-x/cmp-treesitter",
	"saadparwaiz1/cmp_luasnip",
	"zbirenbaum/copilot-cmp",
	{ "David-Kunz/cmp-npm", dependencies = { "nvim-lua/plenary.nvim" } },
}

M.event = "InsertEnter"

function M.config()
	local cmp = require("cmp")
	local mapping = cmp.mapping
	local config = cmp.config

	cmp.setup({
		experimental = { ghost_text = { hl_group = "LspCodeLens" } },
		formatting = formatting,
		mapping = mapping.preset.insert({
			["<C-u>"] = mapping.scroll_docs(-4),
			["<C-d>"] = mapping.scroll_docs(4),
			["<C-Space>"] = mapping.complete(),
			["<C-e>"] = mapping.abort(),
			["<CR>"] = mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
		}),
		snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
		sources = config.sources(
			{ { name = "copilot" }, { name = "nvim_lsp" }, { name = "nvim_lsp_signature_help" } },
			{ { name = "luasnip" }, { name = "treesitter", max_item_count = 5 } },
			{ { name = "buffer" }, { name = "nvim_lua" } },
			{ { name = "obsidian" }, { name = "obsidian_new" }, { name = "npm", keyword_length = 4 } }
		),
		sorting = {
			priority_weight = 2,
			comparators = {
				require("copilot_cmp.comparators").prioritize,
				config.compare.offset,
				config.compare.exact,
				config.compare.score,
				config.compare.recently_used,
				config.compare.locality,
				config.compare.kind,
				config.compare.sort_text,
				config.compare.length,
				config.compare.order,
			},
		},
	})

	luasnip_extend()

	cmp.setup.filetype("gitcommit", {
		sources = config.sources({ { name = "cmp" }, { name = "conventionalcommits" } }, { { name = "buffer" } }),
	})

	cmp.setup.cmdline({ "/", "?" }, {
		mapping = mapping.preset.cmdline(),
		sources = cmp.config.sources({ { name = "nvim_lsp_document_symbol" } }, { { name = "buffer" } }),
	})

	cmp.setup.cmdline(":", {
		mapping = mapping.preset.cmdline(),
		sources = config.sources({ { name = "path" } }, { { name = "cmdline" } }),
	})
end

return M
