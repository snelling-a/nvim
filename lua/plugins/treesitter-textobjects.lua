---@type LangSpec
return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	config = function()
		require("nvim-treesitter-textobjects").setup({
			move = { enable = true, set_jumps = true },
			select = { lookahead = true, include_surrounding_whitespace = false },
		})

		local map = require("user.keymap.util").map("TreesitterTextobjects")
		local select = require("nvim-treesitter-textobjects.select")

		---@param object "function"|"class"
		local function select_map(object)
			local key = object:sub(1, 1)
			map({ "x", "o" }, "a" .. key, function()
				select.select_textobject("@" .. object .. ".outer", "textobjects")
			end, { desc = "Select around " .. object })
			map({ "x", "o" }, "i" .. key, function()
				select.select_textobject("@" .. object .. ".inner", "textobjects")
			end, { desc = "Select inside " .. object })
		end
		select_map("function")
		select_map("class")

		local swap = require("nvim-treesitter-textobjects.swap")
		map("n", "<leader>a", function()
			swap.swap_next("@parameter.inner")
		end)
		map("n", "<leader>A", function()
			swap.swap_previous("@parameter.outer")
		end)
	end,
}
