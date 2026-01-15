vim.pack.add({
	{ src = "https://github.com/OXY2DEV/helpview.nvim" },
	{ src = "https://github.com/OXY2DEV/markview.nvim" },
	{ src = "https://github.com/YousefHadder/markdown-plus.nvim" },
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
	{ src = "https://github.com/brianhuster/live-preview.nvim" },
	{ src = "https://tangled.org/cuducos.me/yaml.nvim" },
}, { load = false })

local plugins_path = debug.getinfo(1, "S").source:sub(2):match("(.*/)")

for _, file in ipairs(vim.fn.glob(plugins_path .. "*.lua", false, true)) do
	local name = vim.fn.fnamemodify(file, ":t:r")
	if name ~= "init" then
		require("plugins." .. name)
	end
end
