vim.opt_local.foldlevel = 99
local Autocmd = require("user.autocmd")
local Undo = require("user.undo")

--- @param x any
--- @return integer
local function as_integer(x)
	local nx = assert(tonumber(x))
	assert(nx == math.floor(nx))
	return nx
end

local ut_buf = vim.api.nvim_get_current_buf()
local group = Autocmd.augroup("nvim.undotree")

local render_diff
local new_text_changed = function(buf)
	return vim.api.nvim_create_autocmd("TextChanged", { group = group, buffer = buf, callback = render_diff })
end

local destroy = vim.F.nil_wrap(function()
	vim.api.nvim_win_close(Undo.diff_win, true)
	vim.api.nvim_clear_autocmds({ group = group })
end)

---@type integer
local on_text_changed
render_diff = vim.schedule_wrap(function()
	if not vim.api.nvim_buf_is_valid(ut_buf) then
		return destroy()
	end
	local buf = Undo.buf_from_title(vim.api.nvim_buf_get_name(ut_buf))
	-- -- :tabnew file, undotree, :bd!
	if not vim.api.nvim_buf_is_loaded(buf) then
		return destroy()
	end
	-- only create on new buf
	on_text_changed = on_text_changed or new_text_changed(buf)
	local ut_win = assert(vim.b[buf].nvim_undotree)
	local line = vim.api.nvim_win_call(ut_win, vim.api.nvim_get_current_line)
	Undo.render_diff(buf, as_integer(line:match("%d+")))
end)

-- local hijack = vim.api.nvim_get_autocmds({ group = group0, buffer = ut_buf, event = "CursorMoved" })[1]
vim.api.nvim_create_autocmd("CursorMoved", {
	group = group,
	buffer = ut_buf,
	callback = render_diff,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = group,
	callback = vim.schedule_wrap(function(ev)
		if not vim.api.nvim_buf_is_valid(ut_buf) then
			return destroy()
		end
		local buf = Undo.buf_from_title(vim.api.nvim_buf_get_name(ut_buf))
		if
			ev.buf == ut_buf
			or ev.buf == buf
			or not vim.api.nvim_buf_is_valid(ev.buf)
			or not vim.api.nvim_buf_is_valid(buf)
			or vim.bo[ev.buf].bt ~= ""
		then
			return
		end
		Undo.open({ buf = ut_buf, win = vim.b[buf].nvim_undotree })
		vim.b[buf].nvim_undotree = nil
		pcall(vim.api.nvim_del_autocmd, on_text_changed)
		on_text_changed = new_text_changed(ev.buf)
		render_diff()
	end),
})

vim.api.nvim_create_autocmd({ "WinClosed", "BufWinLeave" }, {
	buffer = ut_buf,
	once = true,
	callback = destroy,
})
