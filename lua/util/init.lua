local M = {}

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
