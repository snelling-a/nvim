local Icons = require("icons")

---@class Statusline
local M = {}

--- @param name string
--- @return table<string,any>
local function get_hl(name)
	return vim.api.nvim_get_hl(0, { name = name, link = false })
end

--- @param num integer
--- @param active 0|1
--- @return string
local function highlight(num, active)
	if active == 1 then
		if num == 1 then
			return "%#PmenuSel#"
		end
		return "%#StatusLine#"
	end
	return "%#StatusLineNC#"
end

local function hldefs()
	local bg = get_hl("StatusLine").bg
	for k, _ in pairs(Icons.diagnostics) do
		local diagnostic_fg = get_hl("Diagnostic" .. k).fg
		vim.api.nvim_set_hl(0, "Diagnostic" .. k .. "Status", { fg = diagnostic_fg, bg = bg })
	end

	local ts_fg = get_hl("MoreMsg").fg
	vim.api.nvim_set_hl(0, "StatusLineTreesitter", { fg = ts_fg, bg = bg })

	local vcs_bg = get_hl("DiffChange").fg
	vim.api.nvim_set_hl(0, "StatuslineVCS", { fg = bg, bg = vcs_bg, bold = true })

	local ruler_bg = get_hl("Special").fg
	vim.api.nvim_set_hl(0, "StatuslineRuler", { fg = bg, bg = ruler_bg, bold = true })
end

--- @param name string
--- @param active 0|1
--- @return string
local function hl(name, active)
	if active == 0 then
		return ""
	end
	return "%#" .. name .. "#"
end

--- @param active 0|1
--- @return string
local function lsp_name(active)
	if active == 0 then
		return ""
	end

	local server_icons = {} ---@type string[]
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		server_icons[#server_icons + 1] = Icons.servers[client.name] or Icons.servers.lsp
	end

	if #server_icons == 0 then
		return ""
	end

	return table.concat(server_icons, " ")
end

local function get_buf_diagnostics()
	local buf_diagnostics = {
		ERROR = 0,
		WARN = 0,
		HINT = 0,
		INFO = 0,
	}

	for _, v in pairs(vim.diagnostic.get(0)) do
		local severities = vim.diagnostic.severity

		local severity = severities[v.severity]
		buf_diagnostics[severity] = buf_diagnostics[severity] + 1
	end
	return buf_diagnostics
end

--- @param active 0|1
--- @return string?
local function diagnostics(active)
	local status = {} ---@type string[]
	local diags = get_buf_diagnostics()
	for k, v in pairs(Icons.diagnostics) do
		local n = diags[k:upper()] or 0
		if n > 0 then
			table.insert(status, (" %s%s %d"):format(hl("Diagnostic" .. k .. "Status", active), v, n))
		end
	end

	if #status == 0 then
		return
	end

	return table.concat(status, " ")
end

--- @param active 0|1
--- @return string
function M.lsp_status(active)
	local status = {} ---@type string[]

	status[#status + 1] = lsp_name(active)
	status[#status + 1] = diagnostics(active)

	return table.concat(status, " ")
end

--- @param active 0|1
--- @return string
function M.vcs(active)
	local status = ""
	if vim.b.gitsigns_status then
		status = (vim.b.gitsigns_head == "main" or vim.b.gitsigns_head == "master") and Icons.git.branch
			or vim.b.gitsigns_head
		if vim.b.gitsigns_status ~= "" then
			---@type string
			status = status .. " " .. vim.b.gitsigns_status
		end
	elseif vim.g.gitsigns_head then
		status = vim.g.gitsigns_head
	end

	if status == "" then
		return status
	end

	return hl("StatuslineVCS", active) .. " " .. status .. " "
end

--- @param active 0|1
--- @return string
local function filetype_symbol(active)
	---@type boolean, table
	local ok, devicons = pcall(require, "nvim-web-devicons")
	if not ok then
		return ""
	end

	local name = vim.api.nvim_buf_get_name(0)
	--- @type string, string
	local icon, iconhl = devicons.get_icon_color(name, vim.bo.filetype, { default = true })

	local hlname = iconhl:gsub("#", "Status")
	vim.api.nvim_set_hl(0, hlname, { fg = iconhl, bg = get_hl("StatusLine").bg })

	return hl(hlname, active) .. icon .. " "
end

local function is_treesitter()
	local bufnr = vim.api.nvim_get_current_buf()

	return vim.treesitter.highlighter.active[bufnr] ~= nil
end

--- @param active 0|1
--- @return string
function M.filetype(active)
	local r = {
		filetype_symbol(active),
	}

	if is_treesitter() then
		r[#r + 1] = hl("StatusLineTreesitter", active) .. " "
	end

	return table.concat(r, " ")
end

function M.encodingAndFormat()
	local e = vim.bo.fileencoding and vim.bo.fileencoding or vim.o.encoding

	local r = {} ---@type string[]
	if e ~= "utf-8" then
		r[#r + 1] = e
	end

	local f = vim.bo.fileformat
	if f ~= "unix" then
		r[#r + 1] = "[" .. f .. "]"
	end

	return table.concat(r, " ")
end

--- @return string
function M.bufname()
	local buf_name = vim.api.nvim_buf_get_name(0)
	if vim.startswith(buf_name, "fugitive://") then
		local _, _, revision, relpath = buf_name:find([[^fugitive://.*/%.git.*/(%x-)/(.*)]])
		if revision then
			return relpath .. "@" .. revision:sub(1, 8)
		end
	elseif vim.startswith(buf_name, "gitsigns://") then
		local _, _, revision, relpath = buf_name:find([[^gitsigns://.*/%.git.*/(.*)[:/](.*)]])
		if revision then
			return relpath .. "@" .. (tonumber(revision, 16) and revision:sub(1, 8) or revision)
		end
	elseif vim.bo.filetype:match("term") then
		return Icons.servers.bashls
	elseif vim.bo.filetype:match("qf") then
		return ""
	end

	return vim.api.nvim_eval_statusline("%f", {}).str
end

-- Set the ruler format
-- e.g. `80% 65[12]/120`
--- @param active 0|1
--- @return string
function M.ruler(active)
	if active == 0 then
		return ""
	end

	return hl("StatuslineRuler", active) .. " %3p%% %2l[%02c]/%-3L "
end

--- @param x string
--- @return string
local function pad(x)
	return "%( " .. x .. " %)"
end

---@type Statusline
local F = setmetatable({}, {
	---@param t Statusline
	---@param name string
	---@return function
	__index = function(t, name)
		---@type function
		t[name] = function(active, mods)
			active = active or 1
			mods = mods or ""
			return "%" .. mods .. "{%v:lua.statusline." .. name .. "(" .. tostring(active) .. ")%}"
		end

		return t[name]
	end,
})

--- @param sections string[][]
--- @return string
local function parse_sections(sections)
	local result = {} ---@type string[]
	for _, s in ipairs(sections) do
		local sub_result = {} ---@type string[]
		for _, part in ipairs(s) do
			sub_result[#sub_result + 1] = part
		end
		result[#result + 1] = table.concat(sub_result)
	end

	return table.concat(result, "%=")
end

--- @param active 0|1
--- @param global? boolean
local function set(active, global)
	local scope = global and "o" or "wo"
	---@type string
	vim[scope].statusline = parse_sections({
		{
			F.vcs(active),
			highlight(2, active),
			pad(F.lsp_status(active)),
			highlight(2, active),
		},
		{
			"%<",
			pad(F.bufname() .. "%m%r%h%q"),
		},
		{
			pad(F.filetype(active)),
			pad(F.encodingAndFormat()),
			highlight(1, active),
			F.ruler(active),
		},
	})
end

local group = vim.api.nvim_create_augroup("statusline", {})

vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
	group = group,
	once = true,
	callback = function()
		vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FocusGained" }, {
			group = group,
			callback = function()
				set(1)
			end,
		})
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
	group = group,
	callback = function()
		set(0)
	end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = group,
	callback = function()
		set(1, true)
	end,
})

vim.api.nvim_create_autocmd({ "ColorScheme", "ColorSchemePre" }, {
	group = group,
	callback = hldefs,
})

hldefs()

local redrawstatus = vim.schedule_wrap(function()
	vim.cmd.redrawstatus()
end)

vim.api.nvim_create_autocmd("User", {
	pattern = "GitSignsUpdate",
	group = group,
	callback = redrawstatus,
})

vim.api.nvim_create_autocmd({ "DiagnosticChanged" }, {
	group = group,
	callback = redrawstatus,
})

_G.statusline = M

return M
