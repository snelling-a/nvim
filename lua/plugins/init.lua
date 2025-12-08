local config_path = vim.fn.stdpath("config") .. "/lua/plugins"

for _, file in ipairs(vim.fn.glob(config_path .. "/*.lua", false, true)) do
	local name = vim.fn.fnamemodify(file, ":t:r")
	if name ~= "init" then
		require("plugins." .. name)
	end
end
