local disabled_filetypes = require("utils.no_format")
local null_ls = require("null-ls")
local on_attach = require("lsp_config").on_attach

local builtins = null_ls.builtins
local builtins_code_actions = builtins.code_actions
local builtins_diagnostics = builtins.diagnostics
local builtins_formatting = builtins.formatting
local builtins_code_actions_typescript = require("typescript.extensions.null-ls.code-actions")

local builtins_diagnostics_cspell = builtins_diagnostics.cspell.with({
	disabled_filetypes = disabled_filetypes,
	diagnostics_postprocess = function(diagnostic) diagnostic.severity = vim.diagnostic.severity["HINT"] end,
})

local builtins_formatting_deno_fmt = builtins.formatting.deno_fmt.with({
	condition = function(utils) return utils.root_has_file({ "deno.json*" }) end,
})

local builtins_formatting_prettierd = builtins.formatting.prettierd.with({
	condition = function(utils)
		return utils.root_has_file({
			".prettier.toml",
			".prettierrc",
			".prettierrc.cjs",
			".prettierrc.js",
			".prettierrc.json",
			".prettierrc.json5",
			".prettierrc.yaml",
			".prettierrc.yml",
			"prettier.config.js",
		})
	end,
})

local function get_yamllint_args()
	local yamllint_args = {}
	if vim.fn.filereadable(".yamllint") == 1 then
		table.insert(yamllint_args, "--config-file")
		table.insert(yamllint_args, vim.fn.getcwd() .. "/.yamllint")
	end
	return yamllint_args
end

null_ls.setup({
	border = "rounded",
	diagnostics_format = "[#{c}] #{m} (#{s})",
	on_attach = on_attach,
	sources = {
		builtins_code_actions.cspell.with({ disabled_filetypes = disabled_filetypes }),
		builtins_code_actions.shellcheck,
		builtins_code_actions_typescript,
		builtins_diagnostics.actionlint,
		builtins_diagnostics.alex,
		builtins_diagnostics.gitlint,
		builtins_diagnostics.luacheck,
		builtins_diagnostics.shellcheck.with({ extra_args = { "-x" } }),
		builtins_diagnostics.todo_comments,
		builtins_diagnostics.vint,
		builtins_diagnostics.yamllint.with({ extra_args = get_yamllint_args }),
		builtins_diagnostics.zsh,
		builtins_diagnostics_cspell,
		builtins_formatting.beautysh,
		builtins_formatting.cbfmt,
		builtins_formatting.jq.with({ extra_args = { "--sort-keys" } }),
		builtins_formatting.shfmt,
		builtins_formatting.stylua,
		builtins_formatting.taplo,
		builtins_formatting.yamlfmt,
		builtins_formatting.yq.with({ args = { "sort_keys(..)" } }),
		builtins_formatting_deno_fmt,
		builtins_formatting_prettierd,
	},
})

require("mason-null-ls").setup({ ensure_installed = nil, automatic_installation = true, automatic_setup = false })
