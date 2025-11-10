---@type LangSpec
return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	config = function()
		require("nvim-treesitter-textobjects").setup({
			move = { set_jumps = true, enable = true },
			select = {
				include_surrounding_whitespace = false,
				lookahead = true,
				selection_modes = { ["@class.outer"] = "<c-v>", ["@function.outer"] = "V", ["@parameter.outer"] = "v" },
			},
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

		local move = require("nvim-treesitter-textobjects.move")
		---@param object "function"
		local function move_map(object)
			local key = object:sub(1, 1)
			map({ "n", "o", "x" }, "]" .. key, function()
				move.goto_next_start("@" .. object .. ".outer", "textobjects")
			end)
			map({ "n", "o", "x" }, "[" .. key, function()
				move.goto_previous_start("@" .. object .. ".outer", "textobjects")
			end)
		end
		move_map("function")

		map({ "n", "x", "o" }, "]o", function()
			move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
		end)
	end,
}
