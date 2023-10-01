local diagnostic_signs = require("config.ui.icons").diagnostics

local api = vim.api

local function setup_diagnostics()
	for type, icon in pairs(diagnostic_signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, {
			icon = icon,
			numhl = hl,
			text = icon,
			texthl = hl,
		})
	end

	vim.diagnostic.config({
		float = {
			source = "always",
			border = "rounded",
		},
		severity_sort = true,
		signs = true,
		underline = true,
		update_in_insert = false,
		virtual_text = false,
	})
end

local function best_diagnostic(diagnostics)
	if vim.tbl_isempty(diagnostics) then
		return
	end

	local best = nil
	local line_diagnostics = {}
	local line_nr = api.nvim_win_get_cursor(0)[1] - 1

	for k, v in pairs(diagnostics) do
		if v.lnum == line_nr then
			line_diagnostics[k] = v
		end
	end

	for _, diagnostic in ipairs(line_diagnostics) do
		if best == nil then
			best = diagnostic
		elseif diagnostic.severity < best.severity then
			best = diagnostic
		end
	end

	return best
end

local function current_line_diagnostics()
	local bufnr = 0
	local line_nr = api.nvim_win_get_cursor(0)[1] - 1
	local opts = {
		["lnum"] = line_nr,
	}

	return vim.diagnostic.get(bufnr, opts)
end

local severity = vim.diagnostic.severity
local virt_options = {
	prefix = "",
	format = function(diagnostic)
		local message = vim.split(diagnostic.message, "\n")[1]

		if diagnostic.severity == severity.ERROR then
			return diagnostic_signs.Error .. message
		elseif diagnostic.severity == severity.INFO then
			return diagnostic_signs.Info .. message
		elseif diagnostic.severity == severity.WARN then
			return diagnostic_signs.Warn .. message
		elseif diagnostic.severity == severity.HINT then
			return diagnostic_signs.Hint .. message
		else
			return message
		end
	end,
}

local name = "LspCurrentLineDiagnostics"

local function set_current_line_vert_handler()
	local virt_handler = vim.diagnostic.handlers.virtual_text
	local ns = api.nvim_create_namespace(name)

	vim.diagnostic.handlers.current_line_virt = {
		show = function(_, bufnr, diagnostics, _)
			local diagnostic = best_diagnostic(diagnostics)
			if not diagnostic then
				return
			end

			local filtered_diagnostics = {
				diagnostic,
			}

			pcall(virt_handler.show, ns, bufnr, filtered_diagnostics, {
				virtual_text = virt_options,
			})
		end,

		hide = function(_, bufnr)
			bufnr = bufnr or api.nvim_get_current_buf()
			virt_handler.hide(ns, bufnr)
		end,
	}
end

--- @param bufnr integer
local function setup_autocmds(bufnr)
	set_current_line_vert_handler()

	local LspDiagnostiCurrentLineGroup = require("config.util").augroup(name)

	api.nvim_clear_autocmds({
		buffer = bufnr,
		group = LspDiagnostiCurrentLineGroup,
	})

	api.nvim_create_autocmd({
		"CursorHold",
		"CursorHoldI",
	}, {
		buffer = bufnr,
		callback = function() vim.diagnostic.handlers.current_line_virt.show(nil, 0, current_line_diagnostics(), nil) end,
		desc = "Show current line diagnostics",
		group = LspDiagnostiCurrentLineGroup,
	})

	api.nvim_create_autocmd({
		"CursorMoved",
	}, {
		buffer = bufnr,
		callback = function() vim.diagnostic.handlers.current_line_virt.hide(nil, nil) end,
		desc = "Hide current line diagnostics",
		group = LspDiagnostiCurrentLineGroup,
	})
end
local M = {}

--- @param client lsp.Client
--- @param bufnr integer
function M.on_attach(client, bufnr)
	setup_diagnostics()

	local method = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

	local ok, diagnostics_supported = pcall(function() return client.supports_method(method) end)

	if not ok or not diagnostics_supported then
		return
	end

	setup_autocmds(bufnr)
end

return M
