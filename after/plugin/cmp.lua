local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local compare = require("cmp.config.compare")
local icons = require("utils.icons")
local luasnip = require("luasnip")

local formatting = {
	fields = { "kind", "abbr", "menu" },
	format = function(entry, vim_item)
		vim_item.kind = icons.kind_icons[vim_item.kind]
		vim_item.menu = icons.cmp[entry.source.name]
		return vim_item
	end,
}

local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local mapping = cmp.mapping.preset.insert({
	["<C-d>"] = cmp.mapping.scroll_docs(4),
	["<C-e>"] = cmp.mapping.abort(),
	["<C-n>"] = cmp.mapping.select_next_item(),
	["<C-p>"] = cmp.mapping.select_prev_item(),
	["<C-Space>"] = cmp.mapping.complete(),
	["<C-u>"] = cmp.mapping.scroll_docs(-4),
	["<C-w>"] = cmp.mapping.close(),
	["<CR>"] = cmp.mapping.confirm({ select = true }),
	["<Tab>"] = vim.schedule_wrap(function(fallback)
		if cmp.visible() and has_words_before() then
			cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
		else
			fallback()
		end
	end),
	["<S-Tab>"] = vim.schedule_wrap(function(fallback)
		if cmp.visible() and has_words_before() then
			cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
		else
			fallback()
		end
	end),
})

compare.lsp_scores = function(entry1, entry2)
	local diff
	if entry1.completion_item.score and entry2.completion_item.score then
		diff = (entry2.completion_item.score * entry2.score) - (entry1.completion_item.score * entry1.score)
	else
		diff = entry2.score - entry1.score
	end
	return (diff < 0)
end

local sorting = {
	priority_weight = 2,
	comparators = {
		require("copilot_cmp.comparators").prioritize,
		require("copilot_cmp.comparators").score,
		compare.offset,
		compare.exact,
		compare.lsp_scores,
		compare.kind,
		compare.sort_text,
		compare.recently_used,
		compare.locality,
		compare.length,
		compare.order,
	},
}

local sources = cmp.config.sources({
	{ name = "nvim_lsp" },
	{ name = "luasnip" },
	{ name = "nvim_lua" },
	{ name = "path" },
	{ name = "treesitter" },
	{ name = "buffer" },
	{ name = "copilot", group_index = 2 },
})

local window = {
	completion = {
		col_offset = -3,
		side_padding = 0,
		winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
	},
	documentation = cmp.config.window.bordered(),
}

cmp.setup({
	formatting = formatting,
	mapping = mapping,
	snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
	sorting = sorting,
	sources = sources,
	window = window,
})

luasnip.filetype_extend("javascript", { "html" })
luasnip.filetype_extend("javascriptreact", { "html", "javascript" })
luasnip.filetype_extend("typescript", { "html", "javascript" })
luasnip.filetype_extend("typescriptreact", { "html", "javascript" })

require("luasnip.loaders.from_vscode").load()

cmp.setup.filetype("gitcommit", { sources = cmp.config.sources({ { name = "cmp_git" } }, { { name = "buffer" } }) })

cmp.setup.cmdline({ "/", "?" }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } })

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

cmp.event:on("menu_opened", function() vim.b.copilot_suggestion_hidden = true end)

cmp.event:on("menu_closed", function() vim.b.copilot_suggestion_hidden = false end)
