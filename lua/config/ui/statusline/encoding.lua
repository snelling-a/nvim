local M = {}

function M.encodingAndFormat()
	local bo = vim.bo
	local e = bo.fileencoding and bo.fileencoding or vim.o.encoding

	local r = {} ---@type string[]

	if e ~= "utf-8" then
		r[#r + 1] = e
	end

	local f = bo.fileformat

	if f ~= "unix" then
		r[#r + 1] = "[" .. f .. "]"

		local ok, res = pcall(vim.api.nvim_call_function, "WebDevIconsGetFileFormatSymbol")

		if ok then
			r[#r + 1] = res
		end
	end

	return table.concat(r, " ")
end

return M
