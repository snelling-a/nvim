local lsp_formatting = "Lsp Formatting"

local Logger = require("config.util.logger"):new(lsp_formatting)
local Util = require("config.util")

local M = {}

--- @type boolean
local AUTOFORMAT = true

local function toggle()
	AUTOFORMAT = not AUTOFORMAT

	if AUTOFORMAT then
		Logger:info("Enabled format on save")
	else
		Logger:warn("Disabled format on save")
	end
end

--- @param client lsp.Client
--- @param bufnr integer
local function format(client, bufnr)
	local formatting_disabled = {
		"eslint",
		"tsserver",
		"typescript-tools",
	}

	client = client or {}
	local ok, result = pcall(function() return not vim.tbl_contains(formatting_disabled, client.name) end or true)
	if not ok then
		return
	end

	vim.lsp.buf.format({
		bufnr = bufnr,
		filter = function() return result end,
		timeout_ms = 1000,
	})
end

--- @param client lsp.Client
--- @param bufnr integer
local function setup_keymaps(client, bufnr)
	local bind = require("config.lsp.util").bind

	bind(bufnr, "<leader>f", function() format(client, bufnr) end, "[F]ormat the current buffer")
	bind(bufnr, "<leader>tf", function() toggle() end, "[T]oggle Auto[f]ormat")
	bind(bufnr, "<leader>sw", function() vim.cmd([[noautocmd write]]) end, "[S]ave [w]ithout formatting")
end

--- @param client lsp.Client
--- @param bufnr integer
local function setup_formatting(client, bufnr)
	local group = require("config.util").augroup(lsp_formatting:gsub(" ", "") .. "." .. bufnr)

	local event = {
		"BufWritePre",
	}

	local opts = {
		buffer = bufnr,
		desc = "Format on save",
		group = group,
	}

	local ok, hl_autocmds = pcall(
		vim.api.nvim_get_autocmds,
		Util.tbl_extend_force(opts, {
			event = event,
		})
	)

	if ok and #hl_autocmds > 0 then
		vim.api.nvim_clear_autocmds({
			group = group,
		})
	end

	vim.api.nvim_create_autocmd(
		event,
		Util.tbl_extend_force(opts, {
			callback = function()
				if AUTOFORMAT then
					format(client, bufnr)
				end
			end,
		})
	)

	vim.api.nvim_create_user_command("AutoformatToggle", function() toggle() end, {
		desc = "Toggle format on save",
		nargs = 0,
	})

	setup_keymaps(client, bufnr)
end

--- @param client lsp.Client
--- @param bufnr integer
function M.on_attach(client, bufnr)
	local ok, formatting_supported = pcall(function() return client.supports_method("textDocument/formatting") end)

	if not ok or not formatting_supported then
		return
	end

	setup_formatting(client, bufnr)
end

return M
