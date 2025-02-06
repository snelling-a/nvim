local M = {}

-- Remove the listchars for multispace
-- use for languages that utilize multispace for formatting
-- i.e. toml, prisma
function M.remove_multispace_listchar()
	---@type table<string, string>
	local listchars = {}

	for k, v in pairs(require("icons").listchars) do
		if k ~= "multispace" then
			listchars[k] = v
		end
	end

	vim.opt_local.listchars = listchars
end

return M
