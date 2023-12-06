local Logger = require("util").logger:new("Diagnostics")

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
		return Logger:info(("Set %s to %s"):format(option, vim.opt_local[option]:get()))
	end
	---@diagnostic disable-next-line: no-unknown
	vim.opt_local[option] = not vim.opt_local[option]:get()
	if not silent then
		if vim.opt_local[option]:get() then
			Logger:info(("Enabled %s"):format(option))
		else
			Logger:warn(("Disabled %s"):format(option))
		end
	end
end

local enabled = true
function M.diagnostics()
	enabled = not enabled
	if enabled then
		vim.diagnostic.enable()
		Logger:info("Enabled diagnostics")
	else
		vim.diagnostic.disable()
		Logger:warn("Disabled diagnostics")
	end
end

setmetatable(M, {
	__call = function(self, ...)
		return self.option(...)
	end,
})

return M
