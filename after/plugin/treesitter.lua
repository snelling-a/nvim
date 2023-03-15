require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"css",
		"help",
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
		"yaml",
	},
	sync_install = false,
	auto_install = true,
	highlight = { enable = true, additional_vim_regex_highlighting = false },
	textobjects = {
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
	},
	context_commentstring = { enable = true, enable_autocmd = false },
	rainbow = { enable = true, extended_mode = true, max_file_lines = nil },
})

require("treesitter-context").setup({ mode = "topline" })
