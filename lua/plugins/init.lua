vim.pack.add({
	{ src = "https://github.com/iamcco/markdown-preview.nvim" },
	{ src = "https://github.com/OXY2DEV/helpview.nvim" },
	{ src = "https://github.com/OXY2DEV/markview.nvim" },
	{ src = "https://github.com/YousefHadder/markdown-plus.nvim" },
}, { load = false })

vim.api.nvim_create_autocmd({ "PackChanged" }, {
	desc = "Build Markdown Preview",
	group = vim.api.nvim_create_augroup("user.plugins", { clear = true }),
	callback = function(event)
		if event.data.kind == "install" and event.data.spec.name == "markdown-preview.nvim" then
			vim.notify("Building markdown-preview.nvim...", vim.log.levels.INFO)
			local ok = pcall(vim.fn["mkdp#util#install"])
			if ok then
				vim.notify("markdown-preview.nvim built successfully!")
			else
				vim.notify("Error building markdown-preview.nvim: ", vim.log.levels.ERROR)
			end
		end
	end,
})

local plugins_path = debug.getinfo(1, "S").source:sub(2):match("(.*/)")

for _, file in ipairs(vim.fn.glob(plugins_path .. "*.lua", false, true)) do
	local name = vim.fn.fnamemodify(file, ":t:r")
	if name ~= "init" then
		require("plugins." .. name)
	end
end
