local null_ls = require("null-ls")
local builtins = null_ls.builtins
local on_attach = require("lsp_config").on_attach
local disable_filetypes = require("utils.no_format")

local typescript_code_actions = require("typescript.extensions.null-ls.code-actions")

local gitsigns_code_actions = builtins.code_actions.gitsigns.with({
	config = { filter_actions = function(title) return title:lower():match("blame") == nil end },
})

local deno_formatting = builtins.formatting.deno_fmt.with({
	condition = function(utils) return utils.root_has_file({ "deno.json", "deno.jsonc" }) end,
})

null_ls.setup({
	border = "rounded",
	diagnostics_format = "[#{c}] #{m} (#{s})",
	on_attach = on_attach,
	sources = {
		builtins.code_actions.cspell.with({ disable_filetypes = disable_filetypes }),
		builtins.code_actions.eslint_d,
		builtins.code_actions.refactoring,
		builtins.code_actions.shellcheck,
		builtins.completion.luasnip,
		builtins.diagnostics.cspell.with({ disable_filetypes = disable_filetypes, diagnostics_format = "#{m} (#{s})" }),
		builtins.diagnostics.eslint_d,
		builtins.diagnostics.gitlint,
		builtins.diagnostics.luacheck,
		builtins.diagnostics.markdownlint,
		builtins.diagnostics.shellcheck,
		builtins.diagnostics.todo_comments,
		builtins.diagnostics.tsc,
		builtins.diagnostics.vint,
		builtins.diagnostics.yamllint,
		builtins.diagnostics.zsh,
		builtins.formatting.beautysh,
		builtins.formatting.cbfmt,
		builtins.formatting.eslint_d,
		builtins.formatting.jq.with({ extra_args = { "-S" } }), -- sort keys alphabetically
		builtins.formatting.markdownlint,
		builtins.formatting.prettierd,
		builtins.formatting.shellharden,
		builtins.formatting.shfmt,
		builtins.formatting.stylua,
		builtins.formatting.taplo,
		builtins.formatting.yamlfmt,
		deno_formatting,
		gitsigns_code_actions,
		typescript_code_actions,
	},
})

require("mason-null-ls").setup({ ensure_installed = nil, automatic_installation = true, automatic_setup = false })
