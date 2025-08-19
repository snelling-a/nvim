---@alias LspWord {from:{[1]:number, [2]:number}, to:{[1]:number, [2]:number}} 1-0 indexed
local enabled = false
local ns2 = vim.api.nvim_create_namespace("nvim.lsp.references")

---@return LspWord[] words, number? current
local function get()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local current, words = nil, {} ---@type number?, LspWord[]
	local extmarks = {} ---@type vim.api.keyset.get_extmark_item[]
	vim.list_extend(extmarks, vim.api.nvim_buf_get_extmarks(0, ns2, 0, -1, { details = true }))
	for _, extmark in ipairs(extmarks) do
		local w = {
			from = { extmark[2] + 1, extmark[3] },
			to = { extmark[4].end_row + 1, extmark[4].end_col },
		}
		words[#words + 1] = w
		if cursor[1] >= w.from[1] and cursor[1] <= w.to[1] and cursor[2] >= w.from[2] and cursor[2] <= w.to[2] then
			current = #words
		end
	end

	return words, current
end

local function disable()
	if not enabled then
		return
	end
	enabled = false
	vim.api.nvim_del_augroup_by_name("user.lsp.words")
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		vim.api.nvim_buf_clear_namespace(buf, ns2, 0, -1)
	end
end
local M = {}

---@param opts? number|{buf?:number, modes:boolean} if modes is true, also check if the current mode is enabled
---@return boolean
function M.get_is_enabled(opts)
	if not enabled then
		return false
	end
	opts = type(opts) == "number" and { buf = opts } or opts or {}

	if opts.modes then
		local mode = vim.api.nvim_get_mode().mode:lower()
		mode = mode:gsub("\22", "v"):gsub("\19", "s")
		mode = mode:sub(1, 2) == "no" and "o" or mode
		mode = mode:sub(1, 1):match("[ncitsvo]") or "n"
		if not vim.tbl_contains({ "n", "i", "c" }, mode) then
			return false
		end
	end

	local buf = opts.buf or vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = buf })
	---@param client vim.lsp.Client
	---@return boolean
	clients = vim.tbl_filter(function(client)
		return client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, buf)
	end, clients)
	return #clients > 0
end

---@diagnostic disable-next-line: undefined-field
local timer = vim.uv.new_timer()
local function update()
	local buf = vim.api.nvim_get_current_buf()
	if not timer then
		return
	end

	timer:start(200, 0, function()
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_call(buf, function()
					if not M.get_is_enabled({ modes = true }) then
						return
					end
					vim.lsp.buf.document_highlight()
					vim.lsp.buf.clear_references()
				end)
			end
		end)
	end)
end

function M.on_attach()
	if enabled then
		return
	end
	enabled = true

	local group = require("user.autocmd").augroup("lsp.words")

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "ModeChanged", "FocusGained" }, {
		callback = function()
			if not M.get_is_enabled({ modes = true }) then
				vim.lsp.buf.clear_references()
				return
			end
			if not ({ get() })[2] then
				update()
			end
		end,
		desc = "Update LSP words on cursor move or mode change",
		group = group,
	})

	vim.api.nvim_create_autocmd({ "FocusLost", "CmdlineEnter", "BufLeave" }, {
		callback = function()
			vim.lsp.buf.clear_references()
		end,
		desc = "Clear LSP words on focus lost or leaving buffer",
		group = group,
	})

	vim.api.nvim_create_user_command("WordsDisable", disable, {
		desc = "Disable LSP words",
	})
	vim.api.nvim_create_user_command("WordsEnable", M.on_attach, {
		desc = "Enable LSP words",
	})
end

---@param count number
function M.jump(count)
	local words, idx = get()
	if not idx then
		return
	end

	if #words == 1 then
		vim.notify("No references found")
		return
	end

	idx = (idx + count - 1) % #words + 1

	local target = words[idx]
	if target then
		vim.cmd.normal({ "m`", bang = true })
		vim.api.nvim_win_set_cursor(0, target.from)
		vim.notify(("Reference [%d/%d]"):format(idx, #words))
		require("user.keymap.util").feedkeys("zv")
	end
end

return M
