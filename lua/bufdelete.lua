---@alias BufDeleteOpts { force?: boolean }
local M = {}

---@param buf number
---@param opts BufDeleteOpts
local function _delete(buf, opts)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	if vim.bo[buf].modified and not opts.force then
		local ok, choice =
			pcall(vim.fn.confirm, ("Save changes to %q?"):format(vim.fn.bufname(buf)), "&Yes\n&No\n&Cancel")
		if not ok or choice == 0 or choice == 3 then
			return
		elseif choice == 1 then
			vim.api.nvim_buf_call(buf, vim.cmd.write)
		end
	end

	local info = vim.fn.getbufinfo({ buflisted = 1 })
	---@param b vim.fn.getbufinfo.ret.item
	---@return boolean
	info = vim.tbl_filter(function(b)
		return b.bufnr ~= buf
	end, info)
	---@param a vim.fn.getbufinfo.ret.item
	---@param b vim.fn.getbufinfo.ret.item
	---@return boolean
	table.sort(info, function(a, b)
		return a.lastused > b.lastused
	end)

	local new_buf = info[1] and info[1].bufnr or vim.api.nvim_create_buf(true, false)

	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		local win_buf = vim.api.nvim_win_call(win, function()
			local alt = vim.fn.bufnr("#")
			if alt >= 0 and alt ~= buf and vim.bo[alt].buflisted then
				return alt
			end
			return new_buf
		end)
		vim.api.nvim_win_set_buf(win, win_buf)
	end

	if vim.api.nvim_buf_is_valid(buf) then
		pcall(vim.cmd.bwipeout, { buf, bang = true })
	end
end

---Delete current buffer without disrupting window layout
---@param opts? BufDeleteOpts
function M.delete(opts)
	_delete(vim.api.nvim_get_current_buf(), opts or {})
end

---Delete all buffers
---@param opts? BufDeleteOpts
function M.all(opts)
	opts = opts or {}
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted then
			_delete(buf, opts)
		end
	end
end

---Delete all buffers except current
---@param opts? BufDeleteOpts
function M.other(opts)
	opts = opts or {}
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted and buf ~= current then
			_delete(buf, opts)
		end
	end
end

---Delete buffer by name
---@param name string
---@param opts? BufDeleteOpts
function M.by_name(name, opts)
	local buf = vim.fn.bufnr(name)
	if buf ~= -1 then
		_delete(buf, opts or {})
	end
end

return M
