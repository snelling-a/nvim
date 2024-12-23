---@type LazySpec
return {
	"echasnovski/mini.pairs",
	event = { "InsertEnter" },
	config = function()
		local pairs = require("mini.pairs")
		pairs.setup()

		local open = pairs.open
		---@param pair __pairs_pair
		---@param neigh_pattern __pairs_neigh_pattern
		---@return string|unknown
		---@diagnostic disable-next-line: duplicate-set-field
		pairs.open = function(pair, neigh_pattern)
			if vim.fn.getcmdline() ~= "" then
				return open(pair, neigh_pattern)
			end

			local filetypes = { "markdown", "copilot-chat" }

			local opening, closing = pair:sub(1, 1), pair:sub(2, 2)
			local current_line = vim.api.nvim_get_current_line()
			local cursor_position = vim.api.nvim_win_get_cursor(0)
			local content_before = current_line:sub(1, cursor_position[2])

			if opening == "`" and vim.tbl_contains(filetypes, vim.bo.filetype) and content_before:match("^%s*``") then
				return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
			end

			local next_letter = current_line:sub(cursor_position[2] + 1, cursor_position[2] + 1)

			if next_letter:match([=[[%w%%%'%[%"%.%`%$]]=]) then
				return opening
			end

			local okay, captures = pcall(
				vim.treesitter.get_captures_at_pos,
				0,
				cursor_position[1] - 1,
				math.max(cursor_position[2] - 1, 0)
			)

			if okay then
				for _, capture in ipairs(captures) do
					if capture.capture == "string" then
						return opening
					end
				end
			end

			if next_letter == closing and closing ~= opening then
				local _, count_open = current_line:gsub(vim.pesc(pair:sub(1, 1)), "")
				local _, count_close = current_line:gsub(vim.pesc(pair:sub(2, 2)), "")

				if count_close > count_open then
					return opening
				end
			end

			return open(pair, neigh_pattern)
		end
	end,
}
