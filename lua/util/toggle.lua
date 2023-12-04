local Util = require("util")

---@class util.toggle
local M = {}

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.option(option, silent, values)
	if values then
		if vim.opt_local[option]:get() == values[1] then
			vim.opt_local[option] = values[2]
		else
			vim.opt_local[option] = values[1]
		end
		return Util.logger:info(("Set %s to %s"):format(option, vim.opt_local[option]:get()))
	end
	---@diagnostic disable-next-line: no-unknown
	vim.opt_local[option] = not vim.opt_local[option]:get()
	if not silent then
		if vim.opt_local[option]:get() then
			Util.logger:info(("Enabled %s"):format(option))
		else
			Util.logger:warn(("Disabled %s"):format(option))
		end
	end
end

local enabled = true
function M.diagnostics()
	enabled = not enabled
	if enabled then
		vim.diagnostic.enable()
		Util.logger:info({
			msg = "Enabled diagnostics",
			title = "Diagnostics",
		})
	else
		vim.diagnostic.disable()
		Util.logger:warn({
			msg = "Disabled diagnostics",
			title = "Diagnostics",
		})
	end
end

setmetatable(M, {
	__call = function(m, ...)
		return m.option(...)
	end,
})

return M
