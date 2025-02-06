local M = {}

-- prepends given module name to the description of the keymap
---@param str string module name
---@return fun(mode: string, lhs: string, rhs: string|function, opts?: vim.keymap.set.Opts) vim.keymap.set
function M.map(str)
	---@param mode string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
	---@param lhs string           Left-hand side |{lhs}| of the mapping.
	---@param rhs string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
	---@param opts? vim.keymap.set.Opts
	return function(mode, lhs, rhs, opts)
		opts = opts or {}
		opts.desc = ("%s: %s"):format(str, (opts.desc or ""))

		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

return M
