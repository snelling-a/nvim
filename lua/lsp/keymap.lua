local Keymap = require("keymap")
local Lsp = require("lsp")

local Methods = vim.lsp.protocol.Methods

local function get_diagnostic_keymaps(bufnr)
	---@param lhs DiagnosticLhs
	---@param text DiagnosticText
	---@param severity lsp.DiagnosticSeverity|nil
	local function unimpaired(lhs, text, severity)
		local diagnostic = vim.diagnostic

		Keymap.unimpaired(lhs, {
			left = function()
				diagnostic.goto_prev({ severity = severity })
			end,
			right = function()
				diagnostic.goto_next({ severity = severity })
			end,
		}, {
			base = "Go to ",
			text = { left = ("previous %s"):format(text), right = ("next %s"):format(text) },
		}, { buffer = bufnr })
	end

	local severity = vim.diagnostic.severity

	---@type UnimpairedSpec
	local specs = {
		["d"] = { text = "[d]iagnostic", severity = nil },
		["e"] = { text = "[e]rror", severity = severity.ERROR },
		["w"] = { text = "[w]arning", severity = severity.WARN },
	}

	for lhs, spec in pairs(specs) do
		unimpaired(lhs, spec.text, spec.severity)
	end
end

---@param method string
---@param bufnr integer
local function has(method, bufnr)
	local opts = { bufnr = bufnr }
	local clients = Lsp.util.get_clients(opts)

	for _, client in ipairs(clients) do
		if client.supports_method(method, opts) then
			return true
		end
	end

	return false
end

local function get_leader_keymaps(bufnr)
	local format = Lsp.format

	local function leader(lhs, rhs, desc, mode)
		Keymap.leader(lhs, rhs, { buffer = bufnr, desc = desc }, mode)
	end

	leader("tf", format.toggle, "[T]oggle auto[f]ormat (global)")
	leader("tF", function()
		format.toggle(true)
	end, "[T]oggle auto[f]ormat (buffer)")
	leader("td", require("util").toggle.diagnostics, "[T]oggle [d]iagnostics")
	leader("d", vim.diagnostic.open_float, "Line [D]iagnostics")
	leader("f", function()
		format({ force = true })
	end, "[F]ormat", { "n", "v" })
	leader("li", vim.cmd.LspInfo, "Lsp Info")

	if has(Methods.textDocument_codeAction, bufnr) then
		leader("ca", vim.lsp.buf.code_action, "[C]ode [a]ction", { "n", "v" })
		leader("cA", function()
			vim.lsp.buf.code_action({
				context = {
					only = { "source" },
					diagnostics = {},
				},
			})
		end, "Source [a]ction", { "n", "v" })
	end

	if has(Methods.textDocument_rename, bufnr) then
		leader("rn", vim.lsp.buf.rename, "[R]e[n]ame")
	end
end

local function get_normal_keymaps(bufnr)
	local function nmap(lhs, rhs, desc)
		Keymap.nmap(lhs, rhs, { buffer = bufnr, desc = desc })
	end

	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("gY", vim.lsp.buf.type_definition, "[G]oto t[y]pe definition")
	nmap("K", vim.lsp.buf.hover, "Hover")

	if has(Methods.textDocument_definition, bufnr) then
		nmap("gd", function()
			vim.lsp.buf.definition({ reuse_win = true })
		end, "[G]oto [D]efinition")
	end

	if has(Methods.textDocument_references, bufnr) then
		nmap("gr", function()
			vim.lsp.buf.references({ includeDeclaration = false })
		end, "[R]eferences")
	end

	if has(Methods.textDocument_signatureHelp, bufnr) then
		local desc = "Signature Help"

		nmap("gK", vim.lsp.buf.signature_help, desc)
		Keymap.imap("<C-K>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = desc })
	end
end

---@class lsp.keymap
local M = {}

function M.on_attach(_, bufnr)
	get_diagnostic_keymaps(bufnr)
	get_leader_keymaps(bufnr)
	get_normal_keymaps(bufnr)
end

return M
