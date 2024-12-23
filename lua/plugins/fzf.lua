---@type LazySpec
return {
	"ibhagwan/fzf-lua",
	cmd = { "FzfLua" },
	event = { "VeryLazy" },
	keys = {
		{ '<leader>"', desc = "Fzf registers" },
		{ "<leader>'", desc = "Fzf marks" },
		{ "<leader>.", desc = "Fzf resume" },
		{ "<leader>fb", desc = "Fzf: Find buffers" },
		{ "<leader>fc", desc = "Fzf: Find colorschemes" },
		{ "<leader>ff", desc = "Fzf: Find files" },
		{ "<leader>fg", desc = "Fzf: Find live_grep" },
		{ "<leader>fh", desc = "Fzf: Find helptags" },
		{ "<leader>fk", desc = "Fzf: Find keymaps" },
		{ "<leader>fl", desc = "Fzf: Find loclist" },
		{ "<leader>fo", desc = "Fzf: Find oldfiles" },
		{ "<leader>fq", desc = "Fzf: Find quickfix" },
		{ "<leader>frG", desc = "Fzf: Find grep_cWORD" },
		{ "<leader>frg", desc = "Fzf: Find grep_cword", mode = { "n", "x" } },
		{ "<leader>ft", desc = "Fzf: Find tabs" },
		{ "<leader>hl", desc = "Fzf highlights" },
	},
	config = function()
		local fzf = require("fzf-lua")

		local image_previewer = { "chafa", "--format", "symbols" }

		fzf.setup({
			files = {
				fzf_opts = {
					["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-files-history",
				},
				fd_opts = [[--color=never --type f --hidden --no-ignore-vcs]],
			},
			grep = {
				fzf_opts = { ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history" },
			},
			previewers = {
				builtin = {
					extensions = { ["png"] = image_previewer, ["jpg"] = image_previewer, ["svg"] = image_previewer },
					treesitter = { enabled = true },
				},
			},
		})

		local map = Config.keymap("FzfLua")

		map({ "n" }, "<leader>fb", fzf.buffers, { desc = "find buffers" })
		map({ "n" }, "<leader>fc", fzf.colorschemes, { desc = "find colorschemes" })
		map({ "n", "v", "i" }, "<C-x><C-f>", fzf.complete_path, { desc = "fuzzy complete path" })
		map({ "n" }, "<leader>ff", fzf.files, { desc = "find files" })
		map({ "n" }, "<leader>frG", fzf.grep_cWORD, { desc = "find grep_cWORD" })
		map({ "n" }, "<leader>frg", fzf.grep_cword, { desc = "find grep_cword" })
		map({ "n" }, "<leader>fh", fzf.helptags, { desc = "find helptags" })
		map({ "n" }, "<leader>hl", fzf.highlights, { desc = "highlights" })
		map({ "n" }, "<leader>fk", fzf.keymaps, { desc = "find keymaps" })
		map({ "n" }, "<leader>fg", fzf.live_grep, { desc = "find live_grep" })
		map({ "n" }, "<leader>fl", fzf.loclist, { desc = "find loclist" })
		map({ "n" }, "<leader>'", fzf.marks, { desc = "marks" })
		map({ "n" }, "<leader>fo", fzf.oldfiles, { desc = "find oldfiles" })
		map({ "n" }, "<leader>fq", fzf.quickfix, { desc = "find quickfix" })
		map({ "n" }, '<leader>"', fzf.registers, { desc = "registers" })
		map({ "n" }, "<leader>.", fzf.resume, { desc = "resume" })
		map({ "n" }, "<leader>ft", fzf.tabs, { desc = "find tabs" })

		fzf.register_ui_select()
	end,
}
