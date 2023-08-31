local Logger = require("config.util.logger")
local Util = require("config.util")

local M = {}

local lsp_formatting = "LspFormatting"

--- @type boolean
local AUTOFOMRMAT = true

local function toggle()
	AUTOFOMRMAT = not AUTOFOMRMAT

	if AUTOFOMRMAT then
		Logger.info({
			msg = "Enabled format on save",
			title = lsp_formatting,
		})
	else
		Logger.warn({
			msg = "Disabled format on save",
			title = lsp_formatting,
		})
	end
end

local function format(client, bufnr)
	local formatting_disabled = {
		"tsserver",
		"typescript-tools",
	}

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

local function setup_keymaps(client, bufnr)
	local bind = require("config.lsp.util").bind

	bind(bufnr, "<leader>f", function() format(client, bufnr) end, "[F]ormat the current buffer")
	bind(bufnr, "<leader>tf", function() toggle() end, "[T]oggle Auto[f]ormat")
	bind(bufnr, "<leader>sw", function() vim.cmd([[noautocmd write]]) end, "[S]ave [w]ithout formatting")
end

local function setup_formatting(client, bufnr)
	local group = require("config.util").augroup(lsp_formatting .. "." .. bufnr)

	local event = {
		"BufWritePre",
	}

	local opts = {
		buffer = bufnr,
		desc = "Format on save",
		group = Util.augroup(lsp_formatting .. "." .. bufnr),
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
				if AUTOFOMRMAT then
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

function M.on_attach(client, bufnr)
	local ok, formatting_supported = pcall(function() return client.supports_method("textDocument/formatting") end)

	if not ok or not formatting_supported then
		return
	end

	setup_formatting(client, bufnr)
end

return M
