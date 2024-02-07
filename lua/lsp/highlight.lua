---@class lsp.highlight
local M = {}

local ns = vim.api.nvim_create_namespace("vim_lsp_float")

---@param buf integer
local function add_inline_highlights(buf)
	for line_index, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
		local patterns = {
			["@%S+"] = "@parameter",
			["^%s*(Parameters:)"] = "@text.title",
			["^%s*(Return:)"] = "@text.title",
			["^%s*(See also:)"] = "@text.title",
			["{%S-}"] = "@parameter",
			["|%S-|"] = "@text.reference",
		}

		for pattern, hl_group in pairs(patterns) do
			local from = 1 ---@type integer?
			while from do
				local to
				from, to = line:find(pattern, from)
				if from then
					vim.api.nvim_buf_set_extmark(buf, ns, line_index - 1, from - 1, {
						end_col = to,
						hl_group = hl_group,
					})
				end
				from = to and to + 1 or nil
			end
		end
	end
end

---@param handler function(err: any, result: any, ctx: any, config: any): integer?, integer?
---@param focusable boolean
---@return fun(err: any, result: any, ctx: any, config: any)
function M.enhanced_float_handler(handler, focusable)
	return function(err, result, ctx, config)
		local bufnr, winnr = handler(
			err,
			result,
			ctx,
			require("util").tbl_extend_force(config or {}, {
				anchor_bias = "above",
				border = "rounded",
				focusable = focusable,
				max_height = math.floor(vim.o.lines * 0.5),
				max_width = math.floor(vim.o.columns * 0.4),
			})
		)

		if not bufnr or not winnr then
			return
		end

		vim.wo[winnr].concealcursor = "n"
		add_inline_highlights(bufnr)

		if focusable and not vim.b[bufnr].markdown_keys then
			require("keymap").nmap("K", function()
				local url = (vim.fn.expand("<cWORD>") --[[@as string]]):match("|(%S-)|")
				if url then
					return vim.cmd.help(url)
				end

				local col = vim.api.nvim_win_get_cursor(0)[2] + 1
				local from, to
				from, to, url = vim.api.nvim_get_current_line():find("%[.-%]%((%S-)%)")
				if from and col >= from and col <= to then
					vim.system({ "open", url }, nil, function(res)
						if res.code ~= 0 then
							---@type LSP
							require("lsp").logger()
							require("lsp")
							vim.notify(("Failed to open URL `%s`"):format(url), vim.log.levels.ERROR)
						end
					end)
				end
			end, { buffer = bufnr, silent = true })
			vim.b[bufnr].markdown_keys = true
		end
	end
end

function M.stylize_markdown()
	---@param bufnr integer
	---@param contents string[]
	---@param opts table
	---@return string[]
	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
		contents = vim.lsp.util._normalize_markdown(contents, {
			width = vim.lsp.util._make_floating_popup_size(contents, opts),
		})
		vim.bo[bufnr].filetype = "markdown"
		vim.treesitter.start(bufnr)
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

		add_inline_highlights(bufnr)

		return contents
	end
end
return M
