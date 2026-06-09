vim.pack.add({ { src = "https://github.com/dmtrKovalenko/fff.nvim" } })

vim.api.nvim_create_autocmd({ "PackChanged" }, {
	callback = function(ev)
		---@type string,"install"|"update"
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "fff.nvim" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("fff.nvim")
			end
			require("fff.download").download_or_build_binary()
		end
	end,
})

require("fff").setup({
	layout = {
		prompt_position = "top",
	},
	lazy_sync = true,
	debug = { enabled = true, show_scores = true },
})

vim.keymap.set("n", "<leader>ff", function()
	require("fff").find_files()
end, { desc = "FFFind files" })
vim.keymap.set("n", "<leader>fg", function()
	require("fff").live_grep()
end, { desc = "LiFFFe grep" })
vim.keymap.set("n", "<leader>fw", function()
	require("fff").live_grep({ query = vim.fn.expand("<cword>") })
end, { desc = "Search current word" })
vim.keymap.set("n", "<leader>fz", function()
	require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
end, { desc = "Search current word" })

local r = require("fff").file_search(
	"button",
	{
		mode = "mixed",
		max_results = 50,
		page = 0,
		current_file = nil,
		max_threads = 4,
		cwd = nil,
		wait_for_index_ms = nil,
	}
)
for _, item in ipairs(r.items) do
	print(item.type, item.relative_path)
end
