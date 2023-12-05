local M = { "mfussenegger/nvim-lint" }

M.event = { "FileLoaded" }

M.opts = {
	events = { "BufWritePost", "BufReadPost", "InsertLeave" },
	linters_by_ft = {
		sh = { "shellcheck" },
	},
}

function M.config(_, opts)
	local F = {}

	local lint = require("lint")

	if #(opts.linters or {}) > 0 then
		for name, linter in pairs(opts.linters) do
			if type(linter) == "table" and type(lint.linters[name]) == "table" then
				lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
			else
				lint.linters[name] = linter
			end
		end
	end

	lint.linters_by_ft = opts.linters_by_ft

	function F.debounce(ms, fn)
		local timer = vim.loop.new_timer()
		return function(...)
			local argv = { ... }
			timer:start(ms, 0, function()
				timer:stop()
				vim.schedule_wrap(fn)(unpack(argv))
			end)
		end
	end

	function F.lint()
		-- Use nvim-lint's logic first:
		-- * checks if linters exist for the full filetype first
		-- * otherwise will split filetype by "." and add all those linters
		-- * this differs from conform.nvim which only uses the first filetype that has a formatter
		local names = lint._resolve_linter_by_ft(vim.bo.filetype)

		-- Add fallback linters.
		if #names == 0 then
			vim.list_extend(names, lint.linters_by_ft["_"] or {})
		end

		-- Add global linters.
		vim.list_extend(names, lint.linters_by_ft["*"] or {})

		-- Filter out linters that don't exist or don't match the condition.
		local ctx = { filename = vim.api.nvim_buf_get_name(0) }
		ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
		names = vim.tbl_filter(function(name)
			local linter = lint.linters[name]
			if not linter then
				require("util.logger"):warn({ msg = ("Linter not found: %s"):format(name), title = "nvim-lint" })
			end
			---@diagnostic disable-next-line: undefined-field
			return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
		end, names)

		-- Run linters.
		if #names > 0 then
			lint.try_lint(names)
		end
	end

	vim.api.nvim_create_autocmd(opts.events, {
		callback = F.debounce(100, F.lint),
		group = require("autocmd").augroup("NvimLint"),
	})
end

return M
