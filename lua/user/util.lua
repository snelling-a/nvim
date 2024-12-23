---@class user.Util
local M = {}

---@param bufnr integer
function M.easy_quit(bufnr)
	vim.bo[bufnr].buflisted = false
	vim.keymap.set("n", "q", function()
		if M.is_man(bufnr) then
			vim.cmd.quitall()
		end

		xpcall(vim.cmd.close, function()
			vim.cmd.bwipeout()
		end)

		vim.cmd.wincmd("p")
	end, { buffer = bufnr, desc = "Quit Buffer" })
end

---@param bufnr integer
---@return boolean
function M.is_man(bufnr)
	return vim.bo[bufnr].filetype == "man"
end

---@param ft? string file type
---@return boolean Disabled is file type disabled
function M.is_filetype_disabled(ft)
	ft = ft or vim.bo.ft
	for _, value in pairs(DisabledFiletypes) do
		if ft:match(value) then
			return true
		end
	end

	return false
end

return M
