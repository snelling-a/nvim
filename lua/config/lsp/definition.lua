local Logger = require("config.util.logger"):new("LSP Definition")

local method = vim.lsp.protocol.Methods.textDocument_definition

local api = vim.api
local fn = vim.fn
local util = vim.lsp.util

local float_win = nil

local function preview_location(result)
	local uri = result.targetUri or result.uri
	if uri == nil then
		return
	end

	local bufnr = vim.uri_to_bufnr(uri)
	if not api.nvim_buf_is_loaded(bufnr) then
		fn.bufload(bufnr)
	end
	local range = result.targetRange or result.range
	local before, after = math.min(5, range.start.line), 10
	local lines = api.nvim_buf_get_lines(bufnr, (range.start.line - before), (range["end"].line + after + 1), false)

	for _, l in ipairs(lines) do
		if #l > 0 then
			break
		end
		before = before - 1
	end

	local ft = api.nvim_get_option_value("filetype", {
		buf = bufnr,
	})

	local buf, win = util.open_floating_preview(lines, ft, {})

	api.nvim_win_set_config(win, {
		border = "rounded",
	})

	local buf_opts = {
		["bufhidden"] = "wipe",
		["modifiable"] = false,
		["filetype"] = ft,
	}

	for name, value in pairs(buf_opts) do
		api.nvim_set_option_value(name, value, {
			buf = bufnr,
		})
	end

	local win_opts = {
		["winhighlight"] = "Normal:Normal,FloatBorder:FloatBorder",
		["cursorline"] = true,
		["number"] = false,
		["statuscolumn"] = "%=" .. require("config.ui.icons").fillchars.foldsep,
	}

	for name, value in pairs(win_opts) do
		api.nvim_set_option_value(name, value, {
			win = win,
		})
		-- vim.api.nvim_win_set_option(win, name, value)
	end

	api.nvim_win_set_cursor(win, {
		before + 1,
		1,
	})

	local pos = range.start.line == range["end"].line
			and {
				before + 1,
				range.start.character + 1,
				range["end"].character - range.start.character,
			}
		or {
			before + 1,
		}

	api.nvim_win_call(win, function()
		fn.matchaddpos("Cursor", {
			pos,
		})
	end)

	return buf, win
end

local function preview_location_callback(_, result, ctx)
	if result == nil or vim.tbl_isempty(result) then
		local _ = Logger:info("") and Logger:error("Error running LSP query: " .. ctx.method)

		return nil
	end

	local definition = result[1] or result

	_, float_win = preview_location(definition)
end

local function peek_definition(bufnr)
	if float_win ~= nil then
		pcall(api.nvim_win_hide, float_win)
	end
	if vim.tbl_contains(api.nvim_list_wins(), float_win) then
		--- @diagnostic disable-next-line: param-type-mismatch
		api.nvim_set_current_win(float_win)
	else
		local params = util.make_position_params()
		return vim.lsp.buf_request(bufnr, method, params, preview_location_callback)
	end
end

local M = {}

function M.handler(_, result, ctx, config)
	if result == nil or vim.tbl_isempty(result) then
		local _ = Logger:info("") and Logger:error("Error running LSP query: " .. ctx.method)

		return nil
	end
	local client = vim.lsp.get_client_by_id(ctx.client_id) or {}

	config = config or {}

	local definition = result[1] or result

	local reuse_win = vim.uri_from_bufnr(0) == definition.targetUri
	local offset_encoding = client.offset_encoding or "utf-8"

	local jump_args = {
		definition,
		offset_encoding,
		reuse_win,
	}

	if vim.tbl_islist(result) then
		local items = util.locations_to_items(result, offset_encoding)
		local list = {
			title = "LSP Definitions",
			items = items,
		}

		if config.on_list then
			pcall(function() assert(type(config.on_list) == "function", "on_list is not a function") end)
			config.on_list(list)
		else
			if #result == 1 then
				util.jump_to_location(unpack(jump_args))

				return
			end

			fn.setqflist({}, " ", list)

			vim.cmd.copen()
		end
	else
		util.jump_to_location(unpack(jump_args))
	end
end

--- @param client lsp.Client
--- @param bufnr integer
function M.on_attach(client, bufnr)
	local ok, definition_supported = pcall(function() return client.supports_method(method) end)

	if not ok or not definition_supported then
		return
	end

	require("config.lsp.util").bind(bufnr, "<leader>gd", function() peek_definition(bufnr) end, "Peek [d]efinition")
end

return M
