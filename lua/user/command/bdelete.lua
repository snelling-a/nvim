---@alias filter fun(bufnr: number): boolean Filter buffers to delete

--- Delete a buffer:
--- - either the current buffer if `buf` is not provided
--- - or every buffer for which `buf` returns true if it is a function
---@param filter? filter
local function delete(filter)
	if filter then
		for _, bufnr in ipairs(vim.tbl_filter(filter, vim.api.nvim_list_bufs())) do
			if vim.bo[bufnr].buflisted then
				delete()
			end
		end

		vim.cmd.tabonly()

		return
	end

	local bufnr = vim.api.nvim_get_current_buf()

	vim.api.nvim_buf_call(bufnr, function()
		if vim.bo.modified then
			local ok, choice =
				pcall(vim.fn.confirm, ("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
			if not ok or choice == 0 or choice == 3 then
				return
			end
			if choice == 1 then
				vim.cmd.write()
			end
		end

		for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
			vim.api.nvim_win_call(win, function()
				if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= bufnr then
					return
				end
				local alt = vim.fn.bufnr("#")
				if alt ~= bufnr and vim.fn.buflisted(alt) == 1 then
					vim.api.nvim_win_set_buf(win, alt)
					return
				end

				---@diagnostic disable-next-line: param-type-mismatch
				local has_previous = pcall(vim.cmd, "bprevious")
				if has_previous and bufnr ~= vim.api.nvim_win_get_buf(win) then
					return
				end

				local new_buf = vim.api.nvim_create_buf(true, false)
				vim.api.nvim_win_set_buf(win, new_buf)
			end)
		end
		if vim.api.nvim_buf_is_valid(bufnr) then
			---@diagnostic disable-next-line: param-type-mismatch
			pcall(vim.cmd, "bdelete! " .. bufnr)
		end
	end)
end

local M = {}

--- Delete all buffers
function M.all()
	return delete(function()
		return true
	end)
end

--- Delete all buffers except the current one
function M.others()
	delete(function(bufnr)
		return bufnr ~= vim.api.nvim_get_current_buf()
	end)
end

---@overload fun(filter?: filter)
return setmetatable(M, {
	__call = function(...)
		return delete(...)
	end,
})
