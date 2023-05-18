local M = { "jose-elias-alvarez/null-ls.nvim" }

M.dependencies = { "jay-babu/mason-null-ls.nvim", "williamboman/mason.nvim" }

function M.config()
	local disabled_filetypes = require("config.util.constants").no_format
	local null_ls = require("null-ls")

	local builtins = null_ls.builtins
	local builtins_code_actions = builtins.code_actions
	local builtins_diagnostics = builtins.diagnostics
	local builtins_formatting = builtins.formatting

	local builtins_diagnostics_cspell = builtins_diagnostics.cspell.with({
		disabled_filetypes = disabled_filetypes,
		diagnostics_postprocess = function(diagnostic) diagnostic.severity = vim.diagnostic.severity["HINT"] end,
	})

	local builtins_diagnostics_luacheck = builtins_diagnostics.luacheck.with({
		condition = function(utils) return utils.root_has_file({ ".luacheckrc" }) end,
	})

	local builtins_diagnostics_yamllint = builtins_diagnostics.yamllint.with({
		extra_args = function()
			if vim.fn.filereadable(".yamllint") == 1 then
				local config_file = vim.fn.getcwd() .. "/.yamllint"
				return { "--config-file", config_file }
			end
			return {}
		end,
		condition = function(utils) return utils.root_has_file({ ".yamllint", ".yamllint.yaml", ".yamllint.yml" }) end,
	})

	local builtins_diagnostics_shellcheck = builtins_diagnostics.shellcheck.with({ extra_args = { "-x" } })

	local builtins_diagnostics_vale =
		builtins_diagnostics.vale.with({ condition = function(utils) return utils.root_has_file({ ".vale.ini" }) end })

	local builtins_formatting_deno_fmt = builtins.formatting.deno_fmt.with({
		condition = function(utils) return utils.root_has_file({ "deno.json*" }) end,
	})

	local builtins_formatting_prettierd = builtins.formatting.prettierd.with({
		condition = function(utils)
			return utils.root_has_file({
				".prettierrc",
				".prettierrc.cjs",
				".prettierrc.js",
				".prettierrc.json",
				".prettierrc.json5",
				".prettierrc.toml",
				".prettierrc.yaml",
				".prettierrc.yml",
				"prettier.config.cjs",
				"prettier.config.js",
			})
		end,
	})

	null_ls.setup({
		border = "rounded",
		diagnostics_format = "[#{c}] #{m} (#{s})",
		on_attach = require("config.lsp").on_attach,
		sources = {
			builtins_code_actions.cspell.with({ disabled_filetypes = disabled_filetypes }),
			builtins_code_actions.shellcheck,
			builtins_diagnostics.gitlint,
			builtins_diagnostics_shellcheck,
			builtins_diagnostics.todo_comments,
			builtins_diagnostics.vint,
			builtins_diagnostics.zsh,
			builtins_diagnostics_cspell,
			builtins_diagnostics_luacheck,
			builtins_diagnostics_vale,
			builtins_diagnostics_yamllint,
			builtins_formatting.cbfmt,
			builtins_formatting.jq,
			builtins_formatting.shfmt,
			builtins_formatting.stylua,
			builtins_formatting.taplo,
			builtins_formatting.yamlfmt,
			builtins_formatting_deno_fmt,
			builtins_formatting_prettierd,
		},
	})

	require("mason-null-ls").setup({ ensure_installed = nil, automatic_installation = true, automatic_setup = false })
end

return M
