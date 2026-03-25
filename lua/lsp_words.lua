---@alias LspWord {from:{[1]:number, [2]:number}, to:{[1]:number, [2]:number}}

local enabled = false
---@type uv.uv_timer_t|nil
local timer = nil
---@type integer|nil
local group = nil

local ns = vim.api.nvim_create_namespace("nvim.lsp.references")

local DEBOUNCE_MS = 200
local VALID_MODES = { n = true, i = true, c = true }

---@return LspWord[] words, number? current
local function get_words()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local current = nil
	---@type LspWord[]
	local words = {}

	for _, extmark in ipairs(vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, { details = true })) do
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
---@param count number
local function jump(count)
	local words, idx = get_words()
	if not idx then
		return
	end

	if #words == 1 then
		vim.notify("No other references")
		return
	end

	idx = (idx + count - 1) % #words + 1
	local target = words[idx]

	if target then
		vim.cmd.normal({ "m`", bang = true })
		vim.api.nvim_win_set_cursor(0, target.from)
		vim.notify(("Reference [%d/%d]"):format(idx, #words))
		vim.cmd.normal({ "zv", bang = true })
	end
end

local M = {}

---@param mode string
---@return string
local function normalize_mode(mode)
	mode = mode:lower()
	if mode:sub(1, 2) == "no" then
		return "o"
	end
	local first = mode:gsub("\22", "v"):gsub("\19", "s"):sub(1, 1)
	return first:match("[ncitsvo]") or "n"
end

---@return boolean
local function has_highlight_support()
	local buf = vim.api.nvim_get_current_buf()
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
		if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, buf) then
			return true
		end
	end
	return false
end

---@return boolean
local function is_enabled()
	if not enabled then
		return false
	end

	local mode = normalize_mode(vim.api.nvim_get_mode().mode)
	if not VALID_MODES[mode] then
		return false
	end

	return has_highlight_support()
end

local function request_highlight()
	local buf = vim.api.nvim_get_current_buf()

	if timer then
		timer:stop()
	else
		timer = assert(vim.uv.new_timer())
	end

	timer:start(DEBOUNCE_MS, 0, function()
		vim.schedule(function()
			if not vim.api.nvim_buf_is_valid(buf) then
				return
			end
			vim.api.nvim_buf_call(buf, function()
				if is_enabled() then
					vim.lsp.buf.clear_references()
					vim.lsp.buf.document_highlight()
				end
			end)
		end)
	end)
end

local function on_cursor_move()
	if not is_enabled() then
		vim.lsp.buf.clear_references()
		return
	end

	local _, current = get_words()
	if not current then
		request_highlight()
	end
end

local function disable()
	if not enabled then
		return
	end
	enabled = false

	if timer then
		timer:stop()
		timer:close()
		timer = nil
	end

	if group then
		pcall(vim.api.nvim_del_augroup_by_id, group)
		group = nil
	end

	pcall(vim.keymap.del, { "n", "x", "o" }, "]]")
	pcall(vim.keymap.del, { "n", "x", "o" }, "[[")


	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
		end
	end
end

function M.enable()
	if enabled then
		return
	end
	enabled = true

	group = vim.api.nvim_create_augroup("lsp.words", { clear = true })

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "ModeChanged", "FocusGained" }, {
		group = group,
		callback = on_cursor_move,
		desc = "LSP document highlight",
	})

	vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "CmdlineEnter" }, {
		group = group,
		callback = vim.lsp.buf.clear_references,
		desc = "Clear LSP references",
	})

	vim.keymap.set({ "n", "x", "o" }, "]]", function()
		jump(vim.v.count1)
	end, { desc = "Next reference" })

	vim.keymap.set({ "n", "x", "o" }, "[[", function()
		jump(-vim.v.count1)
	end, { desc = "Prev reference" })
end

vim.api.nvim_create_user_command("LspWordsToggle", function()
	if enabled then
		disable()
		vim.notify("LSP word highlighting disabled")
	else
		M.enable()
		vim.notify("LSP word highlighting enabled")
	end
end, { desc = "Toggle LSP word highlighting" })

return M
