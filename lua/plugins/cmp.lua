local Icons = require("config.ui.icons")
local Util = require("config.util")

local cmdline_view = {
	entries = {
		name = "wildmenu",
		separator = Icons.fillchars.foldsep,
	},
}

local formatting = {
	fields = {
		"kind",
		"abbr",
		"menu",
	},
	format = function(entry, vim_item)
		vim_item.kind = Icons.kind_icons[vim_item.kind]
		vim_item.menu = Icons.cmp[entry.source.name]
		return vim_item
	end,
}

local function enabled()
	local context = require("cmp.config.context")
	if vim.api.nvim_get_mode().mode == "c" then
		return true
	else
		return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
	end
end

local function get_comparators()
	local compare = require("cmp").config.compare

	return {
		require("copilot_cmp.comparators").prioritize,
		compare.offset,
		compare.exact,
		compare.score,
		compare.recently_used,
		compare.locality,
		compare.kind,
		compare.sort_text,
		compare.length,
		compare.order,
	}
end

local function get_mapping()
	local function has_words_before()
		local unpack = unpack or table.unpack
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local cmp = require("cmp")
	local luasnip = require("luasnip")

	local mapping = cmp.mapping

	return mapping.preset.insert({
		["<C-Space>"] = mapping(mapping.complete(), {
			"i",
			"c",
		}),
		["<C-b>"] = mapping.scroll_docs(-1),
		["<C-e>"] = mapping({
			i = mapping.abort(),
			c = mapping.close(),
		}),
		["<C-f>"] = mapping.scroll_docs(1),
		["<C-j>"] = mapping.select_next_item(),
		["<C-k>"] = mapping.select_prev_item(),
		["<C-y>"] = mapping.confirm({
			select = true,
		}),
		["<CR>"] = mapping.confirm({
			select = false,
		}),
		["<Tab>"] = mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	})
end

local function get_sources()
	local cmp = require("cmp")

	local default_sources = cmp.config.sources({
		{
			name = "copilot",
		},
		{
			name = "nvim_lsp",
		},
		{
			name = "nvim_lsp_signature_help",
		},
	}, {
		{
			name = "luasnip",
		},
	}, {
		{
			name = "buffer",
		},
		{
			name = "nvim_lua",
		},
	}, {
		{
			name = "npm",
			keyword_length = 4,
		},
	})

	vim.api.nvim_create_autocmd("BufReadPre", {
		callback = function(event)
			local sources = default_sources
			if not Util.is_buf_big(event.buf) then
				sources[#sources + 1] = {
					name = "treesitter",
					group_index = 2,
					keyword_length = 4,
				}
			end

			cmp.setup.buffer({
				sources = sources,
			})
		end,
		group = Util.augroup("CmpConditionalSources"),
	})
end

local function get_window()
	return require("cmp").config.window.bordered({
		border = "rounded",
		winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
		col_offset = -3,
		side_padding = 1,
	})
end

local function luasnip_extend()
	local extend = require("luasnip").filetype_extend

	extend("javascript", {
		"html",
	})
	extend("javascriptreact", {
		"html",
		"javascript",
	})
	extend("typescript", {
		"html",
		"javascript",
	})
	extend("typescriptreact", {
		"html",
		"javascript",
	})
end

--- @type LazySpec
local M = {
	"hrsh7th/nvim-cmp",
}

M.cond = Util.is_vim()

M.dependencies = {
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lsp-document-symbol",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-path",
	"L3MON4D3/LuaSnip",
	"ray-x/cmp-treesitter",
	"saadparwaiz1/cmp_luasnip",
	"zbirenbaum/copilot-cmp",
}

M.event = {
	"BufAdd",
	"SessionLoadPost",
	"CmdlineEnter",
}

M.opts = {
	enabled = enabled,
	experimental = {
		ghost_text = {
			hl_group = "LspCodeLens",
		},
	},
	formatting = formatting,
	snippet = {
		expand = function(args) require("luasnip").lsp_expand(args.body) end,
	},
}

function M.config(_, opts)
	local cmp = require("cmp")

	local config, mapping, setup = cmp.config, cmp.mapping, cmp.setup

	setup(Util.tbl_extend_force(opts, {
		confirm_opts = {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		mapping = get_mapping(),
		sorting = {
			priority_weight = 2,
			comparators = get_comparators(),
		},
		sources = get_sources(),
		window = {
			completion = get_window(),
			documentation = get_window(),
		},
	}))

	luasnip_extend()

	require("luasnip.loaders.from_vscode").lazy_load()

	setup.filetype("gitcommit", {
		sources = config.sources({
			{
				name = "git",
			},
			{
				name = "conventionalcommits",
			},
		}, {
			{
				name = "buffer",
			},
		}),
		window = {
			completion = get_window(),
		},
	})

	setup.cmdline({
		"/",
		"?",
	}, {
		mapping = mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{
				name = "nvim_lsp_document_symbol",
			},
		}, {
			{
				name = "buffer",
			},
		}),
		view = cmdline_view,
	})

	setup.cmdline(":", {
		mapping = mapping.preset.cmdline(),
		sources = config.sources({
			{
				name = "path",
			},
		}, {
			{
				name = "cmdline",
			},
		}),
		view = cmdline_view,
	})
end

return M
