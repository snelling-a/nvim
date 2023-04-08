local ensure_installed = {
	"bash",
	"css",
	"javascript",
	"json",
	"jsonc",
	"lua",
	"markdown",
	"markdown_inline",
	"regex",
	"scss",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

local rainbow = { enable = true, query = "rainbow-parens", strategy = require("ts-rainbow").strategy.global }

local textobjects = {
	select = {
		enable = true,
		lookahead = true,
		lsp_interop = {
			enable = true,
			border = "none",
			floating_preview_opts = {},
			peek_definition_code = { ["<leader>df"] = "@function.outer", ["<leader>dF"] = "@class.outer" },
		},
		keymaps = {
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["aa"] = "@parameter.outer",
			["ia"] = "@parameter.inner",
			["ac"] = "@call.outer",
			["ic"] = "@call.inner",
			["ao"] = "@block.outer",
			["io"] = "@block.inner",
		},
	},
}

require("nvim-treesitter.configs").setup({
	auto_install = true,
	context_commentstring = { enable = true, enable_autocmd = false },
	ensure_installed = ensure_installed,
	highlight = { enable = true, additional_vim_regex_highlighting = { "markdown" } },
	rainbow = rainbow,
	sync_install = false,
	textobjects = textobjects,
})

require("treesitter-context").setup({ mode = "topline" })
require("ts_context_commentstring.internal").calculate_commentstring({
	location = require("ts_context_commentstring.utils").get_cursor_location(),
})
