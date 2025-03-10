---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
	build = ":TSUpdate",
	event = { "VeryLazy" },
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

		vim.keymap.set({ "n" }, "<leader>tt", function()
			local is_enabled = vim.b.ts_highlight

			if is_enabled then
				vim.treesitter.stop()
			else
				vim.treesitter.start()
			end
		end, { desc = "Toggle Treesitter Highlight" })
	end,
}
