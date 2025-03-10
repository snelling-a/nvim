---@type LazySpec
return {
	"tpope/vim-fugitive",
	cmd = {
		"G",
		"Git",
		"Gvdiffsplit",
	},
	keys = {
		{ "<leader>gs", desc = "Fugitive: [G]it [s]tatus" },
	},
	config = function()
		---@diagnostic disable-next-line: no-unknown
		local Git = vim.cmd.Git

		local map = vim.keymap.set

		map({ "n" }, "<leader>gs", function()
			Git({ mods = { vertical = true } })
		end, { desc = "[G]it [s]tatus" })

		local group = vim.api.nvim_create_augroup("Fugitive", {})
		vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
			callback = function(event)
				if vim.bo.filetype ~= "fugitive" then
					return
				end

				map({ "n" }, "<leader>p", function()
					Git("push")
				end, { buffer = event.buf, desc = "Git [p]ush" })
				map({ "n" }, "<leader>P", function()
					Git("pull --rebase")
				end, { buffer = event.buf, desc = "Git [P]ull" })
				map({ "n" }, "<leader>t", function()
					Git("push -u origin")
				end, { buffer = event.buf, desc = "Push [t]o origin" })
			end,
			desc = "Set fugitive keymaps",
			group = group,
			pattern = "*",
		})
	end,
}
