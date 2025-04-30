---@type LazySpec
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			css = { "stylelint" },
			dockerfile = { "hadolint" },
			html = { "htmlhint" },
			lua = { "luacheck" },
			make = { "checkmake" },
			markdown = { "markdownlint-cli2" },
			sh = { "shellcheck" },
			sql = { "sqlfluff" },
			terraform = { "tflint" },
			vim = { "vint" },
			yaml = { "yamllint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				if vim.opt_local.modifiable:get() then
					lint.try_lint()
				end
			end,
		})
	end,
}
