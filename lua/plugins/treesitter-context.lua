---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter-context",
	event = { "LazyFile" },
	config = function()
		local treesitter_context = require("treesitter-context")
		treesitter_context.setup({ max_lines = vim.opt.scrolloff:get() })

		local map = vim.keymap.set

		map("n", "[c", function()
			treesitter_context.go_to_context(vim.v.count1)
		end, { desc = "Jump to [C]ontext" })

		map("n", "<leader>c", treesitter_context.toggle, { desc = "Toggle [C]ontext" })
	end,
}
