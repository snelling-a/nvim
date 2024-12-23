---@type LazySpec
return {
	"mfussenegger/nvim-lint",
	event = { "LazyFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			css = { "stylelint" },
			dockerfile = { "hadolint" },
			html = { "htmlhint" },
			lua = { "luacheck" },
			markdown = { "markdownlint-cli2" },
			sh = { "shellcheck" },
			sql = { "sqlfluff" },
			vim = { "vint" },
			yaml = { "yamllint" },
		}

		---@param timeout integer
		---@param fn function
		---@return function
		local function debounce(timeout, fn)
			local timer = vim.uv.new_timer()
			return function(...)
				local argv = { ... }
				timer:start(timeout, 0, function()
					timer:stop()
					vim.schedule_wrap(fn)(unpack(argv))
				end)
			end
		end

		local function _lint()
			---@type string[]
			local names = lint._resolve_linter_by_ft(vim.bo.filetype)
			---@type string[]
			names = vim.list_extend({}, names)

			if #names == 0 then
				vim.list_extend(names, lint.linters_by_ft["_"] or {})
			end

			vim.list_extend(names, lint.linters_by_ft["*"] or {})

			local ctx = { filename = vim.api.nvim_buf_get_name(0) }
			ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
			---@type string[]
			---@diagnostic disable-next-line: no-unknown
			names = vim.tbl_filter(function(name)
				local linter = lint.linters[name]
				if not linter then
					vim.notify("Linter not found: " .. name, vim.log.levels.WARN)
				end
				---@diagnostic disable-next-line: undefined-field
				return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
			end, names)

			if #names > 0 then
				lint.try_lint(names)
			end
		end

		Config.autocmd.create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			callback = debounce(100, _lint),
			group = "NvimLint",
		})
	end,
}
