local M = {}

-- capitalize the first letter of a string
---@param str string Input string
---@return string str Input string with the first letter capitalized
function M.capitalize_first_letter(str)
	return str:sub(1, 1):upper() .. str:sub(2)
end

---@param bufnr integer?
---@return boolean
function M.is_disabled_filetype(bufnr)
	if not bufnr then
		bufnr = vim.api.nvim_get_current_buf()
	end
	return vim.tbl_contains(vim.g.disabled_filetypes, vim.bo[bufnr].filetype)
		or vim.tbl_contains(vim.g.disabled_filetypes, vim.bo[bufnr].buftype)
		or vim.bo[bufnr].filetype == ""
end

return M
