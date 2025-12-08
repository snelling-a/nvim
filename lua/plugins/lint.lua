vim.pack.add({ { src = "https://github.com/mfussenegger/nvim-lint" } }, {
	load = function()
		vim.cmd.packadd("nvim-lint")
		require("lint").linters_by_ft = {
			css = { "stylelint" },
			dockerfile = { "hadolint" },
			html = { "htmlhint" },
			golang = { "golangci-lint" },
			lua = { "luacheck" },
			make = { "checkmake" },
			markdown = { "markdownlint-cli2" },
			sh = { "shellcheck" },
			sql = { "sqlfluff" },
			terraform = { "tflint" },
			vim = { "vint" },
			yaml = { "yamllint" },
		}

		local group = vim.api.nvim_create_augroup("lint", {})
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			callback = function()
				if vim.opt_local.modifiable:get() then
					require("lint").try_lint()
				end
			end,
			desc = "Lint current buffer",
			group = group,
		})
	end,
})
