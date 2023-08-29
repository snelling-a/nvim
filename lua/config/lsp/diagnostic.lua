local diagnostic_signs = require("config.ui.icons").diagnostics

local vim_diagnostic = vim.diagnostic
local api = vim.api

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

	return vim_diagnostic.get(bufnr, opts)
end

local virt_handler = vim_diagnostic.handlers.virtual_text
local ns = api.nvim_create_namespace("current_line_virt")
local severity = vim_diagnostic.severity
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

vim_diagnostic.handlers.current_line_virt = {
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

local M = {}

function M.on_attach(bufnr)
	for type, icon in pairs(diagnostic_signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, {
			text = icon,
			texthl = hl,
			numhl = hl,
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

	local LspDiagnostiCurrentLineGroup = require("config.util").augroup("LspDiagnostiCurrentLine")

	api.nvim_clear_autocmds({
		buffer = bufnr,
		group = LspDiagnostiCurrentLineGroup,
	})

	api.nvim_create_autocmd({
		"CursorHold",
		"CursorHoldI",
	}, {
		buffer = bufnr,
		callback = function() vim_diagnostic.handlers.current_line_virt.show(nil, 0, current_line_diagnostics(), nil) end,
		desc = "Show current line diagnostics",
		group = LspDiagnostiCurrentLineGroup,
	})

	api.nvim_create_autocmd("CursorMoved", {
		buffer = bufnr,
		callback = function() vim_diagnostic.handlers.current_line_virt.hide(nil, nil) end,
		desc = "Hide current line diagnostics",
		group = LspDiagnostiCurrentLineGroup,
	})
end

return M
