local Icons = require("icons")

---@class user.statusline.cache
local M = {}
---@type table<string,vim.api.keyset.get_hl_info>
M.hl_cache = {}
---@type table<integer, table<string,string>>
M.buf_cache = {}

---@param bufnr integer
---@param keys string[]
function M.clear_buf_cache(bufnr, keys)
	if not M.buf_cache[bufnr] then
		return
	end
	if keys then
		for _, k in ipairs(keys) do
			M.buf_cache[bufnr][k] = nil
		end
	else
		M.buf_cache[bufnr] = nil
	end
end

---@param name string
---@return vim.api.keyset.get_hl_info
function M.get_hl(name)
	if M.hl_cache[name] then
		return M.hl_cache[name]
	end
	local ok, val = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	if ok then
		M.hl_cache[name] = val
		return val
	end
	return {}
end

---@param name string
---@param active 1|0
---@param fn fun(bufnr: integer): string
---@return string
function M.cached(name, active, fn)
	if active == 0 then
		return ""
	end
	local bufnr = vim.api.nvim_get_current_buf()
	M.buf_cache[bufnr] = M.buf_cache[bufnr] or {}
	if M.buf_cache[bufnr][name] then
		return M.buf_cache[bufnr][name]
	end
	local result = fn(bufnr)
	M.buf_cache[bufnr][name] = result
	return result
end

function M.hldefs()
	M.hl_cache = {}
	local bg = M.get_hl("StatusLine").bg

	for k in pairs(Icons.diagnostics) do
		local fg = M.get_hl("Diagnostic" .. k).fg
		vim.api.nvim_set_hl(0, "Diagnostic" .. k .. "Status", { fg = fg, bg = bg })
	end

	vim.api.nvim_set_hl(0, "StatusLineTreesitter", { fg = M.get_hl("MoreMsg").fg, bg = bg })
	vim.api.nvim_set_hl(0, "StatuslineVCS", { fg = bg, bg = M.get_hl("DiffChange").fg, bold = true })
	vim.api.nvim_set_hl(0, "StatuslineRuler", { fg = bg, bg = M.get_hl("Special").fg, bold = true })
end

return M
