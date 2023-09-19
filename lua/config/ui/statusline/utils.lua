local M = {}

---comment
--- @param fallback string
--- @return string|nil
--- @return nil|Gitsigns.StatusObj
function M.gitsigns_ok(fallback)
	--- @type boolean, Gitsigns.StatusObj
	local ok, gitsigns = pcall(
		function() return (assert(vim.b.gitsigns_status_dict ~= nil)) and vim.b.gitsigns_status_dict or {} end
	)

	if not ok then
		return fallback, nil
	else
		return nil, gitsigns
	end
end

return M
