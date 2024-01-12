local Logger = require("util.logger"):new("Formatting")
local Util = require("util")
local lazy = require("_lazy")

---@class lsp.format
---@overload fun(opts?: {force?:boolean})
local M = setmetatable({}, {
	__call = function(self, ...)
		return self.format(...)
	end,
})

---@param opts? lsp.Client.format
function M.format(opts)
	opts = Util.tbl_extend_force(opts or {}, lazy.get_opts("nvim-lspconfig").format or {})
	local ok, conform = pcall(require, "conform")

	if ok then
		opts.lsp_fallback = true
		conform.format(opts)
	else
		vim.lsp.buf.format(opts)
	end
end

function M.formatexpr()
	if lazy.has_plugin("conform.nvim") then
		return require("conform").formatexpr()
	end

	return vim.lsp.formatexpr({ timeout_ms = 3000 })
end

---@param opts? Formatter|{filter?: (string|lsp.Client.filter)}
function M.formatter(opts)
	opts = opts or {}
	local filter = opts.filter or {}
	filter = type(filter) == "string" and { name = filter } or filter
	---@cast filter lsp.Client.filter
	---@type Formatter
	local formatter = {
		name = "LSP",
		primary = true,
		priority = 1,
		format = function(bufnr)
			M.format(Util.merge(filter, { bufnr = bufnr }))
		end,
		sources = function(buf)
			local clients = require("lsp").util.get_clients(Util.merge(filter, { bufnr = buf }))
			---@param client lsp.Client
			local ret = vim.tbl_filter(function(client)
				local Methods = vim.lsp.protocol.Methods
				return client.supports_method(Methods.textDocument_formatting)
					or client.supports_method(Methods.textDocument_rangeFormatting)
			end, clients)
			---@param client lsp.Client
			return vim.tbl_map(function(client)
				return client.name
			end, ret)
		end,
	}
	return Util.merge(formatter, opts) --[[@as Formatter]]
end

M.formatters = {} ---@type Formatter[]

---@param formatter Formatter
function M.register(formatter)
	M.formatters[#M.formatters + 1] = formatter
	table.sort(M.formatters, function(a, b)
		return a.priority > b.priority
	end)
end

---@param buf? number
---@return (Formatter|{active:boolean,resolved:string[]})[]
local function resolve(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	local have_primary = false
	---@param formatter Formatter
	return vim.tbl_map(function(formatter)
		local sources = formatter.sources(buf)
		local active = #sources > 0 and (not formatter.primary or not have_primary)
		have_primary = have_primary or (active and formatter.primary) or false
		return setmetatable({
			active = active,
			resolved = sources,
		}, { __index = formatter })
	end, M.formatters)
end

---@param buf? number
local function enabled(buf)
	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
	local g_autoformat = vim.g.autoformat
	local b_autoformat = vim.b[buf].autoformat

	if b_autoformat ~= nil then
		return b_autoformat
	end

	return g_autoformat == nil or g_autoformat
end

---@param buf? number
local function info(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	local gaf = vim.g.autoformat == nil or vim.g.autoformat
	local baf = vim.b[buf].autoformat
	local icons = require("ui.icons").progress
	local error = icons.error
	local done = icons.done
	local lines = {
		"Formatting",
		("%s global %s"):format(gaf and done or error, gaf and "enabled" or "disabled"),
		("%s buffer %s"):format(
			enabled(buf) and done or error,
			baf == nil and "inherit" or baf and "enabled" or "disabled"
		),
	}

	local have = false
	for _, formatter in ipairs(resolve(buf)) do
		if #formatter.resolved > 0 then
			have = true
			lines[#lines + 1] = ("\n%s %s"):format(formatter.name, (formatter.active and "(active)" or ""))
			for _, line in ipairs(formatter.resolved) do
				lines[#lines + 1] = ("%s %s"):format(formatter.active and done or error, line)
			end
		end
	end

	if not have then
		lines[#lines + 1] = "\nNo formatters available for this buffer."
	end

	local msg = table.concat(lines, "\n")
	if enabled then
		Logger:info(msg)
	else
		Logger:warn(msg)
	end
end

---@param buf? boolean
function M.toggle(buf)
	if buf then
		vim.b.autoformat = not enabled()
	else
		vim.g.autoformat = not enabled()
		vim.b.autoformat = nil
	end
	info()
end

---@param opts? {force?:boolean, buf?:number}
local function format(opts)
	opts = opts or {}
	local bufnr = opts.buf or vim.api.nvim_get_current_buf()
	if not ((opts and opts.force) or enabled(bufnr)) then
		return
	end

	local done = false
	for _, formatter in ipairs(resolve(bufnr)) do
		if formatter.active then
			done = true
			Util.try(function()
				return formatter.format(bufnr)
			end, { msg = ("Formatter `%s` failed"):format(formatter) })
		end
	end

	if not done and opts and opts.force then
		Logger:warn("No formatter available")
	end
end

function M.setup()
	-- Autoformat autocmd
	vim.api.nvim_create_autocmd({ "BufWritePre" }, {
		---@param ev Ev
		callback = function(ev)
			format({ buf = ev.buf })
		end,
		group = require("autocmd").augroup("Format"),
	})

	vim.api.nvim_create_user_command("Format", function()
		format({ force = true })
	end, { desc = "Format selection or buffer" })

	vim.api.nvim_create_user_command("FormatInfo", function()
		info()
	end, { desc = "Show info about the formatters for the current buffer" })
end

return M
