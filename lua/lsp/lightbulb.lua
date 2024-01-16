local augroup = require("autocmd").augroup

local name = "Lightbulb"
local ns = vim.api.nvim_create_namespace(name)
local group = augroup(name)
local method = vim.lsp.protocol.Methods.textDocument_codeAction

local updated_bufnr = nil

---@param bufnr number?
---@param line number?
local function update_extmark(bufnr, line)
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	if not line or vim.startswith(vim.api.nvim_get_mode().mode, "i") then
		return
	end

	pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line, -1, {
		virt_text = {
			{ (" %s"):format(require("ui.icons").diagnostics.Hint), "DiagnosticSignHint" },
		},
		hl_mode = "combine",
		priority = 1000,
	})

	updated_bufnr = bufnr
end

---@param bufnr number
local function render(bufnr)
	local line = vim.api.nvim_win_get_cursor(0)[1] - 1
	local diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line)

	local params = vim.lsp.util.make_range_params()
	params.context = {
		diagnostics = diagnostics,
		triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Automatic,
	}

	vim.lsp.buf_request(bufnr, method, params, function(_, res, _)
		if vim.api.nvim_get_current_buf() ~= bufnr then
			return
		end

		update_extmark(bufnr, (res and #res > 0 and line) or nil)
	end)
end

local timer = vim.uv.new_timer()
assert(timer, "Timer was not initialized")

---@param bufnr number
local function update(bufnr)
	timer:stop()
	update_extmark(updated_bufnr)
	timer:start(100, 0, function()
		timer:stop()
		vim.schedule_wrap(function()
			if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_get_current_buf() == bufnr then
				render(bufnr)
			end
		end)
	end)
end

vim.api.nvim_create_autocmd({ "LspAttach" }, {
	---@param ev Ev
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		if not client or not client.supports_method(method) then
			return true
		end

		local buf_group_name = ("%s%d"):format(name, bufnr)
		if pcall(vim.api.nvim_get_autocmds, { group = buf_group_name, buffer = bufnr }) then
			return
		end
		local lb_buf_group = augroup(buf_group_name)
		vim.api.nvim_create_autocmd({ "CursorMoved" }, {
			buffer = bufnr,
			callback = function()
				update(bufnr)
			end,
			desc = "Update lightbulb when moving the cursor in normal/visual mode",
			group = lb_buf_group,
		})
		vim.api.nvim_create_autocmd({ "InsertEnter", "BufLeave" }, {
			buffer = ev.buf,
			callback = function()
				update_extmark(bufnr, nil)
			end,
			desc = "Update lightbulb when entering insert mode or leaving the buffer",
			group = lb_buf_group,
		})
	end,
	desc = "Configure code action lightbulb",
	group = group,
})

vim.api.nvim_create_autocmd({ "LspDetach" }, {
	callback = function(args)
		local buf_group_name = ("User%s%d"):format(name, args.buf)
		pcall(vim.api.nvim_del_augroup_by_name, buf_group_name)
	end,
	desc = "Detach code action lightbulb",
	group = group,
})
