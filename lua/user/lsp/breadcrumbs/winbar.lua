local Icons = require("icons")
local Util = require("user.lsp.breadcrumbs.utils")

---@param range lsp.Range|nil
---@param line number
---@param char number
---@return boolean
local function contains(range, line, char)
	if not range or not range.start or not range["end"] then
		return false
	end
	if line < range.start.line or line > range["end"].line then
		return false
	end
	if line == range.start.line and char < range.start.character then
		return false
	end
	if line == range["end"].line and char > range["end"].character then
		return false
	end
	return true
end

---@param symbols lsp.DocumentSymbol[]|nil
---@param line number
---@param char number
---@param path string[]
local function pick(symbols, line, char, path)
	---@type lsp.DocumentSymbol[]
	local best = {}
	for _, symbol in ipairs(symbols or {}) do
		if symbol.range and contains(symbol.range, line, char) then
			local sub = {}
			pick(symbol.children, line, char, sub)
			if (#sub + 1) > #best then
				best = { symbol, unpack(sub) }
			end
		end
	end
	if best then
		for _, symbol in ipairs(best) do
			if contains(symbol.range, line, char) then
				local kind = Util.get_kind(symbol)
				table.insert(path, kind .. symbol.name)
				pick(symbol.children, line, char, path)
				return
			end
		end
	end
end

---@class lsp.breadcrumbs.Winbar
local M = {}
M.current_symbols = {}

local function update()
	local bufnr = vim.api.nvim_get_current_buf()
	if vim.bo[bufnr].bt ~= "" then
		return
	end

	local file = vim.api.nvim_buf_get_name(bufnr)
	if file == "" then
		return
	end

	local root = ""
	for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if c.root_dir then
			root = c.root_dir
			break
		end
	end
	root = root or vim.fn.getcwd(0)

	local rel = vim.fs.relpath(root, file)
	if not rel or rel == "" then
		rel = file
	end
	if rel:match("^%.") then
		rel = file
	end

	---@type string[]
	local breadcrumbs = {}
	local parts = vim.split(rel, "[/\\]", { trimempty = true })

	for i, component in ipairs(parts) do
		if component ~= "" then
			if i == #parts then
				breadcrumbs[#breadcrumbs + 1] = Util.get_component_icon(component)
			else
				breadcrumbs[#breadcrumbs + 1] = Util.folder_icon .. " " .. component
			end
		end
	end

	local pos = vim.api.nvim_win_get_cursor(0)
	pick(M.current_symbols, pos[1] - 1, pos[2], breadcrumbs)

	vim.api.nvim_set_option_value("winbar", table.concat(breadcrumbs, " " .. Icons.misc.chevron_right), {
		win = vim.api.nvim_get_current_win(),
	})
end

local pending = false
function M.get_winbar()
	if pending then
		return
	end
	pending = true
	vim.schedule(function()
		pending = false
		update()
	end)
end

return M
