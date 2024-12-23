---@class user.Keymap.Toggle.instance
---@field name string
---@field icon? string
---@field color_enabled? string
---@field color_disabled? string
---@field get fun():boolean
---@field set fun(state:boolean)

---@param toggle user.Keymap.Toggle.instance
---@return user.Keymap.Toggle.instance
local function create_toggle(toggle)
	return setmetatable(toggle, {
		__call = function()
			toggle.set(not toggle.get())
			local state = toggle.get()
			if state then
				vim.notify("Enabled " .. toggle.name)
			else
				vim.notify("Disabled " .. toggle.name, vim.log.levels.WARN)
			end
			return state
		end,
	})
end

---@class user.Keymap.Toggle
local M = {}

M.diagnostics = create_toggle({
	name = "Diagnostics",
	get = function()
		return vim.diagnostic.is_enabled()
	end,
	set = function(state)
		vim.diagnostic.enable(state)
	end,
})

M.inlay_hints = create_toggle({
	name = "Inlay Hints",
	get = function()
		return vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
	end,
	set = function(state)
		vim.lsp.inlay_hint.enable(state, { bufnr = 0 })
	end,
})

---@param name string
---@param opts? {values?: {[1]:any, [2]:any}, name?: string}
---@return user.Keymap.Toggle.instance
function M.option(name, opts)
	opts = opts or {}
	local option = name:gsub("%s+", ""):lower()
	local on = opts.values and opts.values[2] or true
	local off = opts.values and opts.values[1] or false

	return create_toggle({
		name = name,
		get = function()
			return vim.opt_local[option]:get() == on
		end,
		set = function(state)
			---@diagnostic disable-next-line: no-unknown
			vim.opt_local[option] = state and on or off
		end,
	})
end

M.treesitter = create_toggle({
	name = "Treesitter Highlight",
	get = function()
		return vim.b.ts_highlight
	end,
	set = function(state)
		if state then
			vim.treesitter.start()
		else
			vim.treesitter.stop()
		end
	end,
})

setmetatable(M, {
	__call = function(m, ...)
		return m.option(...)
	end,
})

return M
