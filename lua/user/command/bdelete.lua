local M = {}

---@param buf? number|fun(buf: number): boolean Target buffer or filter function to close more than 1 buffer
---@return nil
local function delete(buf)
	if type(buf) == "function" then
		for _, b in ipairs(vim.api.nvim_list_bufs()) do
			if vim.bo[b].buflisted and buf(b) then
				delete(b)
				vim.api.nvim_buf_get_name(b)
			end
		end

		if #vim.api.nvim_list_wins() > 1 then
			vim.cmd.wincmd("o")
		end

		return
	end

	buf = buf or 0
	buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

	if buf ~= vim.api.nvim_get_current_buf() then
		return vim.api.nvim_buf_call(buf, delete)
	end

	if vim.bo.modified then
		local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
		if choice == 0 or choice == 3 then
			return
		end
		if choice == 1 then
			vim.cmd.write()
		end
	end

	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		vim.api.nvim_win_call(win, function()
			if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
				return
			end
			local alt = vim.fn.bufnr("#")
			if alt ~= buf and vim.fn.buflisted(alt) == 1 then
				vim.api.nvim_win_set_buf(win, alt)
				return
			end

			---@diagnostic disable-next-line: param-type-mismatch
			local has_previous = pcall(vim.cmd, "bprevious")
			if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
				return
			end

			local new_buf = vim.api.nvim_create_buf(true, false)
			vim.api.nvim_win_set_buf(win, new_buf)
		end)
	end

	if vim.api.nvim_buf_is_valid(buf) then
		---@diagnostic disable-next-line: param-type-mismatch
		pcall(vim.cmd, "bdelete! " .. buf)
	end
end

--- Delete all buffers
function M.all()
	return delete(function()
		return true
	end)
end

--- Delete all buffers except the current one
function M.others()
	return delete(function(b)
		return b ~= vim.api.nvim_get_current_buf()
	end)
end

---@overload fun(buf: number): nil
return setmetatable(M, {
	---@param ... any
	---@return nil
	__call = function(_, ...)
		return delete(...)
	end,
})
