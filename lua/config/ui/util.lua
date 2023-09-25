local M = {}

---@param name string Hightlight group
---@param what? What
---@param mode? any
---@return string|nil
function M.get_hl(name, what, mode)
	local fn = vim.fn

	return fn.synIDattr(fn.synIDtrans(fn.hlID(name)), what or "fg", mode or "gui")
end

return M
