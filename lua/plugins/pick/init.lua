---@type LazySpec
return {
	"echasnovski/mini.pick",
	dependencies = { "echasnovski/mini.icons", "echasnovski/mini.extra", "echasnovski/mini.visits" },
	event = { "VeryLazy" },
	config = function()
		local pick = require("mini.pick")
		local extra = require("mini.extra")

		pick.setup({
			mappings = { scroll_down = "<C-j>", scroll_up = "<C-k>" },
		})
		extra.setup()

		require("mini.visits").setup()

		require("plugins.pick.util")

		local map = require("user.keymap.util").map("Pick")

		map({ "n" }, "<leader>fb", pick.registry.buffers, { desc = "buffers" })
		map({ "n" }, "<leader>fc", pick.registry.colorschemes, { desc = "colorschemes" })
		map({ "n" }, "<leader>ff", pick.registry.files, { desc = "files" })
		map({ "n" }, "<leader>frg", function()
			pick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
		end, { desc = "grep_cword" })
		map({ "n" }, "<leader>fh", pick.builtin.help, { desc = "helptags" })
		map({ "n" }, "<leader>hl", extra.pickers.hl_groups, { desc = "highlights" })
		map({ "n" }, "<leader>fk", extra.pickers.keymaps, { desc = "keymaps" })
		map({ "n" }, "<leader>fg", pick.builtin.grep_live, { desc = "live_grep" })
		map({ "n" }, "<leader>fl", function()
			extra.pickers.list({ scope = "location" })
		end, { desc = "loclist" })
		map({ "n" }, "<leader>'", pick.registry.marks, { desc = "marks" })
		map({ "n" }, "<leader>fq", function()
			extra.pickers.list({ scope = "quickfix" })
		end, { desc = "quickfix" })
		map({ "n" }, '<leader>"', pick.registry.registers, { desc = "registers" })
		map({ "n" }, "<leader>.", pick.registry.resume, { desc = "resume" })
		map({ "n" }, "<leader>ft", pick.registry.tabpages, { desc = "tabs" })

		vim.ui.select = pick.ui_select
	end,
}
