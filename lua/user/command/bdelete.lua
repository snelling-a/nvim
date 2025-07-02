---@class bdelete.Opts
---@field filter? fun(buf: number): boolean Filter buffers to delete

---@param opts? number|bdelete.Opts
local function delete(opts)
	opts = opts or {}
	opts = type(opts) == "number" and { bufnr = opts } or opts
	opts = type(opts) == "function" and { filter = opts } or opts
	---@cast opts bdelete.Opts

	if type(opts.filter) == "function" then
		for _, bufnr in ipairs(vim.tbl_filter(opts.filter, vim.api.nvim_list_bufs())) do
			if vim.bo[bufnr].buflisted then
				delete(vim.tbl_extend("force", {}, opts, { bufnr = bufnr, filter = false }))
			end
		end
		vim.cmd.tabonly()
		vim.cmd.only()
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

				local new_bufnr = vim.api.nvim_create_buf(true, false)
				vim.api.nvim_win_set_buf(win, new_bufnr)
			end)
		end
		if vim.api.nvim_buf_is_valid(bufnr) then
			---@diagnostic disable-next-line: param-type-mismatch
			pcall(vim.cmd, "bdelete! " .. bufnr)
		end
	end)
end

---@class bdelete
---@overload fun(buf?: number|bdelete.Opts)
local M = setmetatable({}, {
	__call = function(...)
		return delete(...)
	end,
})

--- Delete all buffers
function M.all()
	return delete({
		filter = function()
			return true
		end,
	})
end

--- Delete all buffers except the current one
function M.others()
	delete({
		filter = function(b)
			return b ~= vim.api.nvim_get_current_buf()
		end,
	})
end

return M
