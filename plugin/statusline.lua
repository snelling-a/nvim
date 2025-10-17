if vim.g.statusline_loaded or vim.g.vscode then
	return
end
vim.g.statusline_loaded = true

local statusline = require("user.statusline")

---@class Statusline
local M = {}

function M.lsp_status(active)
	if active == 1 then
		active = statusline.components.disable()
	end
	return table.concat({
		statusline.cache.cached("lsp", active, statusline.components.lsp_name),
		statusline.cache.cached("diagnostics", active, statusline.components.diagnostics),
	}, " ")
end

function M.vcs(active)
	if active == 1 then
		active = statusline.components.disable()
	end
	return statusline.cache.cached("vcs", active, statusline.components.vcs)
end

function M.filetype(active)
	if active == 1 then
		active = statusline.components.disable()
	end
	local r = { statusline.cache.cached("filetype_icon", active, statusline.components.filetype_symbol) }
	if statusline.components.is_treesitter_enabled() then
		r[#r + 1] = statusline.hl("StatusLineTreesitter", active) .. require("icons").misc.treesitter .. " %*"
	end
	return table.concat(r, " ")
end

function M.encoding_and_format(active)
	if active == 1 then
		active = statusline.components.disable()
	end
	return statusline.cache.cached("encoding_format", active, statusline.components.encoding_format)
end

local function buf_suffix()
	local buftype = vim.bo.buftype
	if buftype == "" or buftype == "acwrite" then
		return "%m%r%h%q"
	end
	return ""
end

function M.bufname()
	return statusline.cache.cached("bufname", 1, statusline.components.bufname)
end

---@param active 1|0
---@return string
function M.ruler(active)
	if active == 1 then
		active = statusline.components.disable()
	end
	if active == 0 then
		return ""
	end
	return statusline.hl("StatuslineRuler", active) .. " %3p%% %2l[%02c]/%-3L "
end

local function pad(x)
	return "%( " .. x .. " %)"
end

---@type Statusline
local F = setmetatable({}, {
	---@param self Statusline
	---@param name string
	---@return fun(active: integer?, mods: string?): string
	__index = function(self, name)
		---@diagnostic disable-next-line: no-unknown
		self[name] = function(active, mods)
			active = active or 1
			mods = mods or ""
			return "%" .. mods .. "{%v:lua.statusline." .. name .. "(" .. tostring(active) .. ")%}"
		end
		return self[name]
	end,
})

local function set(active, global)
	local scope = global and "o" or "wo"

	if vim.bo.buftype == "quickfix" then
		---@type string
		vim[scope].statusline = [[%(%l/%L%) %{exists('w:quickfix_title')? ' '.w:quickfix_title : ''} ]]
		return
	end

	---@type string
	vim[scope].statusline = statusline.parse_sections({
		{ F.vcs(active), statusline.highlight(2, active), pad(F.lsp_status(active)), statusline.highlight(2, active) },
		{ "%<", pad(F.bufname() .. buf_suffix()) },
		{
			pad(F.filetype(active)),
			pad(F.encoding_and_format(active)),
			statusline.highlight(1, active),
			F.ruler(active),
		},
	})
end

local group = vim.api.nvim_create_augroup("statusline", {})

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
	callback = function(args)
		statusline.cache.clear_buf_cache(args.buf, { "lsp", "diagnostics" })
	end,
	group = group,
})

vim.api.nvim_create_autocmd({ "DiagnosticChanged" }, {
	callback = function(args)
		statusline.cache.clear_buf_cache(args.buf, { "diagnostics" })
	end,
	group = group,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufReadPost", "FileType", "BufFilePost" }, {
	callback = function(args)
		statusline.cache.clear_buf_cache(args.buf, { "filetype_icon", "encoding_format", "bufname" })
	end,
	group = group,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "GitSignsUpdate",
	callback = function()
		statusline.cache.clear_buf_cache(vim.api.nvim_get_current_buf(), { "vcs" })
	end,
	group = group,
})

vim.api.nvim_create_autocmd({ "ColorScheme", "ColorSchemePre" }, { callback = statusline.cache.hldefs, group = group })
statusline.cache.hldefs()

local redrawstatus = vim.schedule_wrap(function()
	vim.cmd.redrawstatus()
end)

vim.api.nvim_create_autocmd({ "DiagnosticChanged", "User" }, {
	pattern = "GitSignsUpdate",
	callback = redrawstatus,
	group = group,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		set(1, true)
	end,
	group = group,
})

vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
	callback = function()
		set(0)
	end,
	group = group,
})
vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
	callback = function()
		vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FocusGained" }, {
			callback = function()
				set(1)
			end,
			group = group,
		})
	end,
	group = group,
	once = true,
})

_G.statusline = M
