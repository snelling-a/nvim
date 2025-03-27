---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
	build = ":TSUpdate",
	event = { "LazyFile" },
	lazy = vim.fn.argc(-1) == 0,
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			highlight = { additional_vim_regex_highlighting = false, enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_decremental = "<bs>",
					node_incremental = "<C-space>",
					scope_incremental = false,
				},
			},
			indent = { enable = true },
			sync_install = false,
			textobjects = {
				move = {
					enable = true,
					goto_next_end = {
						["]A"] = "@parameter.inner",
						["]C"] = "@class.outer",
						["]F"] = "@function.outer",
					},
					goto_next_start = {
						["]a"] = "@parameter.inner",
						["]c"] = "@class.outer",
						["]f"] = "@function.outer",
					},
					goto_previous_end = {
						["[A"] = "@parameter.inner",
						["[C"] = "@class.outer",
						["[F"] = "@function.outer",
					},
					goto_previous_start = {
						["[a"] = "@parameter.inner",
						["[c"] = "@class.outer",
						["[f"] = "@function.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = { ["<leader>a"] = "@parameter.inner" },
					swap_previous = { ["<leader>A"] = "@parameter.inner" },
				},
			},
		})

		local map = require("user.keymap.util").map("Treesitter")

		map({ "n" }, "<leader>tt", function()
			local is_enabled = vim.b.ts_highlight

			if is_enabled then
				vim.treesitter.stop()
			else
				vim.treesitter.start()
			end
		end, { desc = "Toggle Highlight" })

		local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

		map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move, { desc = "Repeat Last Move" })
		map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite, { desc = "Repeat Last Move Opposite" })

		map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { desc = "remap builtin `f`", expr = true })
		map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { desc = "remap builtin `F`", expr = true })
		map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { desc = "remap builtin `t`", expr = true })
		map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { desc = "remap builtin `T`", expr = true })
	end,
}
