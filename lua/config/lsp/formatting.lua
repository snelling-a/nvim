--- @type boolean
_G.AUTOFORMAT = true
--- @type boolean
_G.FORMAT_NOTIFY = true

local LspUtil = require("config.lsp.util")
local Util = require("config.util")

local method = vim.lsp.protocol.Methods.textDocument_formatting

local lsp_formatting = "Lsp Formatting"

local Logger = require("config.util.logger"):new(lsp_formatting)

local block_list = {
	javascript = false,
	javascriptreact = false,
	lua = false,
	typescript = false,
	typescriptreact = false,
}

local formatting_disabled = {
	eslint = true,
	jsonls = true,
	lua_ls = true,
	tsserver = true,
	["typescript-tools"] = true,
}

--- @param clients lsp.Client[]
--- @return lsp.Client[] clients
local function format_filter(clients)
	return vim.tbl_filter(
		function(client) return client.name == "efm" or not formatting_disabled[client.name] end,
		clients
	)
end

--- @param bufnr integer
local function format(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({
		bufnr = bufnr,
	})

	clients = format_filter(clients)

	if #clients == 0 then
		Logger:warn("Format request failed, no matching language servers.")
	end

	for _, client in pairs(clients) do
		if block_list[vim.bo.filetype] then
			Logger:warn(
				("[%s] Formatting for [%s] has been disabled. This file is not being processed."):format(
					client.name,
					vim.bo.filetype
				)
			)
			return
		end

		local params = vim.lsp.util.make_formatting_params({})
		---@diagnostic disable-next-line: invisible
		local result, err = client.request_sync(method, params, 1000, bufnr)

		if result and result.result then
			vim.lsp.util.apply_text_edits(result.result, bufnr, client.offset_encoding)

			if _G.FORMAT_NOTIFY then
				Logger:info(("%s"):format(client.name))
			end
		elseif err then
			Logger:error(("[%s] %s"):format(client.name, err))
		end
	end
end

local toggle = LspUtil.toggle
local function toggle_autoformat() return toggle(_G.AUTOFORMAT, "autoformat") end

--- @param bufnr integer
local function setup_keymaps(bufnr)
	local map_leader = Util.map_leader
	map_leader("f", function() format(bufnr) end, {
		buffer = bufnr,
		desc = "[F]ormat the current buffer",
	})
	map_leader("tf", function() toggle_autoformat() end, {
		buffer = bufnr,
		desc = "[T]oggle Auto[f]ormat",
		noremap = false,
	})
	map_leader("sw", function()
		vim.cmd.write({
			mods = {
				noautocmd = true,
			},
		})
	end, {
		buffer = bufnr,
		desc = "[S]ave [w]ithout formatting",
	})
end

local function setup_user_commands()
	vim.api.nvim_create_user_command("AutoformatToggle", function() toggle_autoformat() end, {
		desc = "Toggle format on save",
		nargs = 0,
	})

	local function toggle_notify() return toggle(_G.FORMAT_NOTIFY, "notifications") end
	vim.api.nvim_create_user_command("FormattingNotificationsToggle", function() toggle_notify() end, {
		desc = "Toggle notifications when formatting",
		nargs = 0,
	})

	vim.api.nvim_create_user_command("FtFormatToggle", function(opts)
		if block_list[opts.args] == nil then
			Logger:warn(("Formatter for [%s] has been recorded in list and disabled."):format(opts.args))

			block_list[opts.args] = true
		else
			block_list[opts.args] = not block_list[opts.args]

			local state = LspUtil.get_state(not block_list[opts.args])
			local str = ("Formatting for [%s] has been %s."):format(opts.args, state)

			if block_list[opts.args] then
				Logger:warn(str)
			else
				Logger:info(str)
			end
		end
	end, {
		desc = "Add/remove filetypes from being formatted",
		complete = "filetype",
		nargs = 1,
	})
end

--- @param bufnr integer
local function setup_formatting(bufnr)
	local group = Util.augroup(lsp_formatting:gsub(" ", "") .. "." .. bufnr)

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
				if _G.AUTOFORMAT then
					format(bufnr)
				end
			end,
		})
	)
end

local M = {}

--- @param client lsp.Client
--- @param bufnr integer
function M.on_attach(client, bufnr)
	local ok, formatting_supported = pcall(function() return client.supports_method(method) end)

	if not ok or not formatting_supported then
		return
	end

	setup_formatting(bufnr)
	setup_user_commands()
	setup_keymaps(bufnr)
end

return M
