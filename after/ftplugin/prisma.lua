---@type table<string, string>
local listchars = {}

for k, v in pairs(Config.icons.listchars) do
	if k ~= "multispace" then
		listchars[k] = v
	end
end

vim.opt_local.listchars = listchars
