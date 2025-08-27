local Icons = require("icons")
local cache = require("user.statusline.cache")
local statusline = require("user.statusline")

local function get_buf_diagnostics(bufnr)
	local diagnostics = { ERROR = 0, WARN = 0, HINT = 0, INFO = 0 }
	for _, v in pairs(vim.diagnostic.get(bufnr)) do
		---@type vim.diagnostic.SeverityName
		local severity = vim.diagnostic.severity[v.severity]
		diagnostics[severity] = diagnostics[severity] + 1
	end
	return diagnostics
end

---@class user.statusline.components
local M = {}

---@param bufnr integer
---@return string
function M.lsp_name(bufnr)
	---@type string[]
	local icons = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		icons[#icons + 1] = Icons.servers[client.name]
	end
	return #icons > 0 and table.concat(icons, " ") or ""
end

---@param bufnr integer
---@return string
function M.diagnostics(bufnr)
	local diags = get_buf_diagnostics(bufnr)
	local status = {}
	for k, v in pairs(Icons.diagnostics) do
		local n = diags[k:upper()] or 0
		if n > 0 then
			table.insert(status, (" %s%s %d"):format(statusline.hl("Diagnostic" .. k .. "Status", 1), v, n))
		end
	end
	return #status > 0 and table.concat(status, " ") or ""
end

function M.vcs()
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
	if status ~= "" then
		status = statusline.hl("StatuslineVCS", 1) .. " " .. status .. " "
	end
	return status
end

---@param bufnr integer
---@return string
function M.filetype_symbol(bufnr)
	---@type boolean, {get_icon_color: fun(string, string, table): (string, string)}
	local ok, devicons = pcall(require, "nvim-web-devicons")
	if not ok then
		return ""
	end
	local name = vim.api.nvim_buf_get_name(bufnr)
	local ft = vim.bo[bufnr].filetype
	local icon, iconhl = devicons.get_icon_color(name, ft, { default = true })
	local hlname = "StatusDevIcon_" .. (ft:gsub("%W", "_"))
	if not cache.hl_cache[hlname] then
		vim.api.nvim_set_hl(0, hlname, { fg = iconhl, bg = cache.get_hl("StatusLine").bg })
		cache.hl_cache[hlname] = true
	end
	return statusline.hl(hlname, 1) .. icon .. " "
end

---@return boolean
function M.is_treesitter_enabled()
	return vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil
end

---@param bufnr integer
---@return string
function M.encoding_format(bufnr)
	local encoding = vim.bo[bufnr].fileencoding or vim.o.encoding
	local format = vim.bo[bufnr].fileformat
	---@type string[]
	local parts = {}
	if encoding ~= "utf-8" then
		parts[#parts + 1] = encoding
	end
	if format ~= "unix" then
		parts[#parts + 1] = "[" .. format .. "]"
	end
	return table.concat(parts, " ")
end

---@param bufnr integer
---@return string
function M.bufname(bufnr)
	local buf_name = vim.api.nvim_buf_get_name(bufnr)

	---@type string
	local result
	if vim.startswith(buf_name, "fugitive://") then
		local _, _, rev, rel = buf_name:find([[^fugitive://.*/%.git.*/(%x+)/(.*)]])
		if rev and rel then
			---@type string
			result = rel .. "@" .. rev:sub(1, 8)
		else
			local _, _, repo = buf_name:find([[^fugitive://(.*)/%.git//?$]])
			if repo then
				---@type string
				result = vim.fn.fnamemodify(repo, ":t") .. " [fugitive]"
			end
		end
	elseif vim.startswith(buf_name, "gitsigns-blame://") then
		local _, _, file = buf_name:find("^gitsigns%-blame://.-/%.git//:%d+:(.*)")
		if file then
			---@type string
			result = file .. " [blame]"
		end
	elseif vim.startswith(buf_name, "gitsigns://") then
		-- existing handling for preview/diff
		local _, _, rev, rel = buf_name:find([[^gitsigns://.*/%.git.*/(.*)[:/](.*)]])
		if rev then
			---@type string
			result = rel .. "@" .. (tonumber(rev, 16) and rev:sub(1, 8) or rev)
		end
	elseif vim.startswith(buf_name, "term://") then
		result = Icons.servers["bash-language-server"]
	elseif vim.bo.filetype:match("qf") then
		result = ""
	elseif buf_name:match("://") then
		result = buf_name:match(".*/(.*)$") or buf_name
	else
		result = vim.api.nvim_eval_statusline("%f", {}).str
	end
	return result
end

---@param bufnr integer?
---@return 0|1
function M.disable(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local buf_name = vim.api.nvim_buf_get_name(bufnr)
	if vim.startswith(buf_name, "ministarter://") then
		return 0
	end
	return 1
end

return M
