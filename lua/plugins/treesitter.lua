---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	branch = "main",
	config = function()
		local treesitter = require("nvim-treesitter")

		---@param buf integer
		local function ensure_treesitter(buf)
			if not vim.api.nvim_buf_is_valid(buf) then
				return
			end

			local filetype = vim.bo[buf].filetype
			if not filetype or filetype == "" or vim.tbl_contains(vim.g.disabled_filetypes, filetype) then
				return
			end

			local language = vim.treesitter.language.get_lang(filetype) or filetype
			if not language or language == "" then
				return
			end

			local parser_installed = vim.tbl_contains(treesitter.get_installed(), language)

			local function start_parser()
				if vim.api.nvim_buf_is_valid(buf) then
					pcall(vim.treesitter.start, buf, language)
				end
			end

			if parser_installed then
				start_parser()
				return
			end

			vim.notify("Treesitter: installing parser for " .. language .. "...", vim.log.levels.INFO)
			treesitter.install(language, { with_sync = false, notify = false })

			-- Poll periodically until parser is available, then start it.
			local retries = 20
			local function check_installed()
				if vim.tbl_contains(treesitter.get_installed(), language) then
					vim.notify("Treesitter: parser for " .. language .. " installed", vim.log.levels.INFO)
					start_parser()
				elseif retries > 0 then
					retries = retries - 1
					vim.defer_fn(check_installed, 500)
				else
					vim.notify("Treesitter: failed to detect parser install for " .. language, vim.log.levels.WARN)
				end
			end

			check_installed()
		end

		vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
			callback = function(args)
				ensure_treesitter(args.buf)
			end,
		})

		local map = require("user.keymap.util").map("Treesitter")

		map({ "n" }, "<leader>tt", function()
			local is_enabled = vim.b.ts_highlight

			if is_enabled then
				vim.treesitter.stop()
			else
				vim.treesitter.start()
			end
		end, { desc = "Toggle Highlight" })
	end,
}
