local icons = require("ui.icons").misc

--  [9ℓ]: text_from_the_first_line  󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼󰇼

local M = {}

function M.foldtext()
	local foldstart, foldend = vim.v.foldstart, vim.v.foldend
	local fold_length = foldend - foldstart + 1

	local first_line = vim.fn.getline(foldstart)
	-- remove opeing delimiters and trim whitespace
	local sanitized_first_line = string.gsub(first_line, "[{=]", ""):gsub(" *$", "")

	return string.format(
		"%s [%i%s]: %s %s ",
		icons.right,
		fold_length,
		icons.l,
		sanitized_first_line,
		icons.right
	)
end

return M
